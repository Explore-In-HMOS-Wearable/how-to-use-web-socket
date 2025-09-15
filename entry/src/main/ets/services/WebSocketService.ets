// WebSocketManager.ets

import { webSocket } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';

@ObservedV2
class WebSocketManager {
  private socket = webSocket.createWebSocket();
  private defaultIpAddress = "wss://ws.postman-echo.com/raw";
  @Trace isConnected: boolean = false;
  @Trace text: string = 'Please Click to Test Websocket';

  setupWebSocket(): void {
    this.socket.on('open', (err: BusinessError, value: Object) => {
      console.log('on open, status:' + JSON.stringify(value));
      this.text = 'on open sending message';
      this.socket.send('Hello from HarmonyOS!', (err: BusinessError, value: boolean) => {
        if (!err) {
          console.log('Message sent successfully');
          this.text = 'Message sent successfully';
        } else {
          console.log('Failed to send message. Err:' + JSON.stringify(err));
          this.text = 'Failed to send message';
        }
      });
    });

    this.socket.on('message', (err: BusinessError, value: string | ArrayBuffer) => {
      console.log('on message, message: ' + value);
      this.text = 'Message came: '+ value;
      if (value === 'Hello from HarmonyOS!') {
        this.socket.close((err: BusinessError, value: boolean) => {
          if (!err) {
            console.log('Connection closed successfully');
          } else {
            console.log('Failed to close connection. Err:' + JSON.stringify(err));
          }
        });
      }
    });

    this.socket.on('close', (err: BusinessError, value: webSocket.CloseResult) => {
      console.log('on close, code: ' + value.code + ', reason: ' + value.reason);
    });

    this.socket.on('error', (err: BusinessError) => {
      console.log('on error, error: ' + JSON.stringify(err));
    });

    this.socket.connect(this.defaultIpAddress, (err: BusinessError, value: boolean) => {
      if (!err) {
        console.log('Connected to Postman Echo');
      } else {
        console.log('Connection failed. Err:' + JSON.stringify(err));
      }
    });
  }

  connectLiveSocket(): void {
    if (this.isConnected) {
      console.log('WebSocket already connected');
      return;
    }

    const apiUrl = ''; // 🔗 TODO: Add your WebSocket URL here, e.g., "wss://example.com/ws"
    this.socket.connect(apiUrl, (err: BusinessError, value: boolean) => {
      if (!err && value) {
        console.log('Connected to WebSocket server');
      } else {
        console.log('Connection failed:', JSON.stringify(err));
      }
    });
  }

  disconnectLiveSocket(): void {
    if (!this.isConnected) {
      console.log('WebSocket is not connected');
      return;
    }

    this.socket.close((err: BusinessError, value: boolean) => {
      if (!err && value) {
        console.log('WebSocket disconnected successfully');
      } else {
        console.log('Disconnection failed:', JSON.stringify(err));
      }
    });
  }

  sendMessage(message: string): void {
    if (!this.isConnected) {
      console.log('Cannot send message — WebSocket not connected');
      return;
    }

    this.socket.send(message, (err: BusinessError, value: boolean) => {
      if (!err && value) {
        console.log('Cannot send message — WebSocket not connected', message);
      } else {
        console.log('Send failed:', JSON.stringify(err));
      }
    });
  }
}

export const webSocketManager = new WebSocketManager();
