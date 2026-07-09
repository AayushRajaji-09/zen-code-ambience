const vscode = require('vscode');
const path = require('path');
const fs = require('fs');

/**
 * Zen Ambience — VS Code Extension
 * Provides ambient soundscapes in a sidebar webview.
 */
function activate(context) {
  console.log('Zen Ambience activating...');

  // ─── Sidebar Provider ───
  const provider = new ZenAmbienceViewProvider(context.extensionUri);
  context.subscriptions.push(
    vscode.window.registerWebviewViewProvider('zenAmbience.sidebar', provider, {
      webviewOptions: { retainContextWhenHidden: true }
    })
  );

  // ─── Command: Open in Editor ───
  context.subscriptions.push(
    vscode.commands.registerCommand('zenAmbience.open', () => {
      const panel = vscode.window.createWebviewPanel(
        'zenAmbience.editor',
        'Zen Ambience',
        vscode.ViewColumn.Beside,
        {
          enableScripts: true,
          retainContextWhenHidden: true,
          localResourceRoots: [vscode.Uri.file(path.join(context.extensionPath, 'media'))]
        }
      );
      panel.webview.html = getWebviewContent(panel.webview, context.extensionUri);
    })
  );
}

function deactivate() {
  // Webviews are disposed automatically
}

// ─── Webview View Provider ───
class ZenAmbienceViewProvider {
  constructor(extensionUri) {
    this._extensionUri = extensionUri;
  }

  resolveWebviewView(webviewView, _context, _token) {
    webviewView.webview.options = {
      enableScripts: true,
      retainContextWhenHidden: true
    };
    webviewView.webview.html = getWebviewContent(webviewView.webview, this._extensionUri);
  }
}

// ─── HTML Generator ───
function getWebviewContent(webview, extensionUri) {
  // Try to load the webview.html from the repo root (sibling of vscode-extension/)
  const possiblePaths = [
    path.join(extensionUri.fsPath, '..', 'zen-code-ambience', 'webview.html'),
    path.join(extensionUri.fsPath, '..', 'webview.html'),
    path.join(extensionUri.fsPath, 'webview.html'),
  ];

  let html = null;
  for (const p of possiblePaths) {
    const resolved = path.resolve(p);
    if (fs.existsSync(resolved)) {
      html = fs.readFileSync(resolved, 'utf-8');
      break;
    }
  }

  if (!html) {
    // Fallback: embedded minimal version
    return getFallbackHtml();
  }

  // VS Code webviews need a specific CSP meta tag
  // Remove any existing CSP or meta tags and add our own
  const csp = `<meta http-equiv="Content-Security-Policy" content="default-src 'none'; style-src 'unsafe-inline'; script-src 'unsafe-inline'; media-src https: http:;">`;

  // Remove existing <meta> and <title>, prepend our CSP
  html = html.replace(/<head>/, `<head>${csp}`);
  html = html.replace(/<\/title>/, '</title><base href="https://aayushrajaji-09.github.io/zen-code-ambience/">');

  return html;
}

function getFallbackHtml() {
  return `<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta http-equiv="Content-Security-Policy" content="default-src 'none'; style-src 'unsafe-inline'; script-src 'unsafe-inline'; media-src https: http:;">
  <title>Zen Ambience</title>
  <style>
    * { margin:0; padding:0; box-sizing:border-box; }
    body {
      background:#0f0f12; color:#f5f5f7;
      font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',system-ui,sans-serif;
      font-size:13px; padding:20px; display:flex; flex-direction:column; align-items:center; justify-content:center; height:100vh; text-align:center;
      -webkit-font-smoothing:antialiased;
    }
    h2 { color:#00f2fe; margin-bottom:8px; }
    p { color:rgba(255,255,255,0.55); max-width:280px; line-height:1.5; }
    .btn {
      margin-top:16px; padding:8px 16px; border:none; border-radius:6px;
      background:rgba(255,255,255,0.08); color:#f5f5f7; cursor:pointer;
      font-family:inherit; font-size:13px; transition:all 0.15s;
    }
    .btn:hover { background:rgba(255,255,255,0.12); }
  </style>
</head>
<body>
  <h2>Zen Ambience</h2>
  <p>Could not load the webview source file.<br>Make sure the repo is cloned with all files.</p>
  <button class="btn" onclick="vscode.commands.executeCommand('zenAmbience.open')">Open in Editor</button>
</body>
</html>`;
}

module.exports = { activate, deactivate };
