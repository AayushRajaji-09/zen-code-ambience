const vscode = require('vscode');
const fs     = require('fs');
const path   = require('path');
const cp     = require('child_process');

// ─── Status bar item (persists outside the panel) ─────────────────
let statusBarItem = null;

class ZenAmbienceViewProvider {
  constructor(extensionUri) {
    this._extensionUri = extensionUri;
    this._view = null;
  }

  resolveWebviewView(webviewView, context, _token) {
    this._view = webviewView;

    webviewView.webview.options = {
      enableScripts: true,
      localResourceRoots: [this._extensionUri]
    };

    webviewView.webview.html = this._getHtmlForWebview(webviewView.webview);

    // ── Receive play-state messages from the webview ───────────────
    webviewView.webview.onDidReceiveMessage(msg => {
      if (msg.type !== 'state' || !statusBarItem) return;

      if (msg.active && msg.channels.length > 0) {
        // Show what's playing in the status bar
        const label = msg.channels.slice(0, 2).join(' · ') +
                      (msg.channels.length > 2 ? ` +${msg.channels.length - 2}` : '');
        statusBarItem.text            = `$(play) ${label}`;
        statusBarItem.tooltip         = `Zen Ambiator — Playing\n${msg.channels.join(', ')}\n\nClick to open panel`;
        statusBarItem.backgroundColor = new vscode.ThemeColor('statusBarItem.warningBackground');
      } else {
        statusBarItem.text            = `$(unmute) Zen Ambiator`;
        statusBarItem.tooltip         = 'Zen Ambiator — Click to open';
        statusBarItem.backgroundColor = undefined;
      }
    });
  }

  _getHtmlForWebview(webview) {
    const htmlPath = path.join(this._extensionUri.fsPath, 'webview.html');
    return fs.readFileSync(htmlPath, 'utf8');
  }
}

function activate(context) {
  // ── Status bar item ───────────────────────────────────────────────
  // Shows what's playing even when the sidebar panel is hidden.
  // Clicking it refocuses the Zen Ambiator panel.
  statusBarItem         = vscode.window.createStatusBarItem(vscode.StatusBarAlignment.Right, 50);
  statusBarItem.text    = '$(unmute) Zen Ambiator';
  statusBarItem.tooltip = 'Zen Ambiator — Click to open';
  statusBarItem.command = 'workbench.view.extension.zen-ambience-container';
  statusBarItem.show();
  context.subscriptions.push(statusBarItem);

  // ── Register webview view provider ───────────────────────────────
  // retainContextWhenHidden: true  →  JS keeps running even when the
  // panel is hidden/collapsed, so audio never stops mid-session.
  const provider = new ZenAmbienceViewProvider(context.extensionUri);
  context.subscriptions.push(
    vscode.window.registerWebviewViewProvider('zen-ambience.view', provider, {
      webviewOptions: { retainContextWhenHidden: true }
    })
  );
}

function deactivate() {
  if (statusBarItem) statusBarItem.dispose();
}

module.exports = { activate, deactivate };
