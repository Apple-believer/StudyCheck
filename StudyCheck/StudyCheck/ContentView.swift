import SwiftUI

struct Todo: Identifiable {
    var id = UUID()
    var title: String
    var createdAt: Date
}

struct ContentView: View {
    var body: some View {
        VStack {
            DigitalClockView()
                .frame(width: 200, height: 80)
                .padding()

            TodoListView()
                .padding()

            StopwatchView()
                .padding()

            Spacer()
        }
    }
}

struct DigitalClockView: View {
    @State private var time = Date()

    var body: some View {
        Text(dateFormatter.string(from: time))
            .font(.system(size: 30, weight: .regular, design: .default))
            .onAppear {
                Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                    time = Date()
                }
            }
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter
    }
}

struct TodoListView: View {
    @State private var todos: [Todo] = []
    @State private var newTodoTitle = ""

    var body: some View {
        VStack {
            List {
                ForEach(todos) { todo in
                    Text(todo.title)
                }
                .onDelete(perform: deleteTodo)
            }
            .listStyle(PlainListStyle())
            .background(Color.white) // 背景色を変更

            HStack {
                TextField("New Todo", text: $newTodoTitle, onCommit: addTodo)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button(action: addTodo) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.green)
                        .frame(width: 30, height: 30)
                }
                .padding()
            }
        }
    }

    func addTodo() {
        let newTodo = Todo(title: newTodoTitle, createdAt: Date())
        todos.append(newTodo)
        newTodoTitle = ""
    }

    func deleteTodo(at offsets: IndexSet) {
        todos.remove(atOffsets: offsets)
    }
}

struct StopwatchView: View {
    @State private var minutes = 0
    @State private var seconds = 0
    @State private var timer: Timer?
    @State private var isTimerRunning = false
    @State private var selectedHour = 0
    @State private var selectedMinute = 0
    
    var body: some View {
        VStack {
            Text(String(format: "%02d:%02d", minutes, seconds))
                .font(.title)
                .padding()
            
            HStack {
                Button(action: startTimer) {
                    Image(systemName: "play.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.blue)
                        .frame(width: 30, height: 30)
                }
                .padding()
                
                Button(action: stopTimer) {
                    Image(systemName: "stop.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.red)
                        .frame(width: 30, height: 30)
                }
                .padding()
                
                
                
                Button(action: resetTimer) {
                    Image(systemName: "arrow.counterclockwise.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.gray)
                        .frame(width: 30, height: 30)
                }
                .padding()
            }
            .frame(height: 50)
            
            
            HStack {
                Text("Hour")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Picker(selection: $selectedHour, label: Text("")) {
                    ForEach(0..<24) { hour in
                        Text("\(hour)")
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: 80, height: 50)
                .clipped()
                .padding(.horizontal)
                .onReceive([selectedHour].publisher.first()) { value in
                    minutes = value * 60 + selectedMinute
                }
                
                Text("Minute")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Picker(selection: $selectedMinute, label: Text("")) {
                    ForEach(0..<60) { minute in
                        Text("\(minute)")
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: 80, height: 50)
                .clipped()
                .padding(.horizontal)
                .onReceive([selectedMinute].publisher.first()) { value in
                    minutes = selectedHour * 60 + value
                }
            }
            .frame(height: 100)
            
            
        }
        
    }
    
    func startTimer() {
        if isTimerRunning {
            return
        }
        isTimerRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if seconds == 0 {
                if minutes == 0 {
                    stopTimer()
                } else {
                    minutes -= 1
                    seconds = 59
                }
            } else {
                seconds -= 1
            }
            selectedHour = minutes / 60
            selectedMinute = minutes % 60
        }
    }
    
    func stopTimer() {
        isTimerRunning = false
        timer?.invalidate()
        timer = nil
    }
    
    func resetTimer() {
        minutes = 0
        seconds = 0
        selectedHour = 0
        selectedMinute = 0
        isTimerRunning = false
        timer?.invalidate()
        timer = nil
    }
}

struct Content_preview: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
