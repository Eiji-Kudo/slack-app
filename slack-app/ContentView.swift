import SwiftUI

struct ContentView: View {
    @State private var messages: [String] = []
    @State private var newMessage: String = ""
    private let slackService = SlackAPIService()
    private let channelID = "YOUR_CHANNEL_ID"
    
    var body: some View {
        VStack {
            List(messages, id: \.self) { message in
                Text(message)
            }
            
            HStack {
                TextField("New message", text: $newMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: {
                    slackService.postMessage(channel: channelID, text: newMessage) { success in
                        if success {
                            fetchMessages()
                            newMessage = ""
                        }
                    }
                }) {
                    Text("Send")
                }
            }
            .padding()
        }
        .onAppear(perform: fetchMessages)
    }
    
    private func fetchMessages() {
        slackService.fetchMessages(channel: channelID) { messages in
            self.messages = messages
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}