const vscode = require('vscode');
const fs = require('fs');
const path = require('path');
const cp = require('child_process');

class ZenAmbienceViewProvider {
  constructor(extensionUri) {
    this._extensionUri = extensionUri;
  }

  resolveWebviewView(webviewView, context, _token) {
    this._view = webviewView;

    webviewView.webview.options = {
      enableScripts: true,
      localResourceRoots: [this._extensionUri]
    };

    webviewView.webview.html = this._getHtmlForWebview(webviewView.webview);
  }

  _getHtmlForWebview(webview) {
    const htmlPath = path.join(this._extensionUri.fsPath, 'webview.html');
    let htmlContent = fs.readFileSync(htmlPath, 'utf8');
    return htmlContent;
  }
}

function activate(context) {
  // Spoken Greeting Easter Egg (invokes Windows TTS synthesizer silently in background)
  try {
    const greetingCmd = `powershell -WindowStyle Hidden -Command "Add-Type -AssemblyName System.Speech; (New-Object System.Speech.Synthesis.SpeechSynthesizer).Speak('Welcome back, Sir. Antigravity environment is initialized.')"`;
    cp.exec(greetingCmd);
  } catch (e) {
    console.error("Startup greeting failed:", e);
  }

  const provider = new ZenAmbienceViewProvider(context.extensionUri);
  context.subscriptions.push(
    vscode.window.registerWebviewViewProvider('zen-ambience.view', provider)
  );
}

function deactivate() {}

module.exports = {
  activate,
  deactivate
};
