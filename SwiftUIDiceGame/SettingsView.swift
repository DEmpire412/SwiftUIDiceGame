import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("selectedColor") private var selectedColor = 0
    @AppStorage("turnsPerPlayer") private var turnsPerPlayer = 3
    
    var body: some View {
        let color = getColorForSelectedIndex(selectedColor)
        
        NavigationView {
            Form {
                Picker("Background Color", selection: $selectedColor) {
                    Text("Green").tag(0)
                        .foregroundColor(.green)
                        .fontDesign(.rounded)
                        .fontWeight(.medium)
                    Text("Red").tag(1)
                        .foregroundColor(.red)
                        .fontDesign(.rounded)
                        .fontWeight(.medium)
                    Text("Orange").tag(2)
                        .foregroundColor(.orange)
                        .fontDesign(.rounded)
                        .fontWeight(.medium)
                    Text("Yellow").tag(3)
                        .foregroundColor(.yellow)
                        .fontDesign(.rounded)
                        .fontWeight(.medium)
                    Text("Blue").tag(4)
                        .foregroundColor(.blue)
                        .fontDesign(.rounded)
                        .fontWeight(.medium)
                    Text("Purple").tag(5)
                        .foregroundColor(.purple)
                        .fontDesign(.rounded)
                        .fontWeight(.medium)
                    Text("Pink").tag(6)
                        .foregroundColor(.pink)
                        .fontDesign(.rounded)
                        .fontWeight(.medium)
                    Text("Gray").tag(7)
                        .foregroundColor(.gray)
                        .fontDesign(.rounded)
                        .fontWeight(.medium)
                }
                .pickerStyle(.inline)
                
                Stepper(value: $turnsPerPlayer, in: 1...10) {
                    Text("Turns per Player: \(turnsPerPlayer)")
                }
            }
            .navigationTitle("Settings")
            .navigationBarItems(trailing: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark.circle")
                    .fontWeight(.semibold)
                    .hoverEffect()
            })
        }
    }
    
    func getColorForSelectedIndex(_ index: Int) -> Color {
        switch index {
        case 0:
            return Color.green
        case 1:
            return Color.red
        case 2:
            return Color.orange
        case 3:
            return Color.yellow
        case 4:
            return Color.blue
        case 5:
            return Color.purple
        case 6:
            return Color.pink
        case 7:
            return Color.gray
        default:
            return Color.green
        }
    }
    
    struct SettingsView_Previews: PreviewProvider {
        static var previews: some View {
            SettingsView()
        }
    }
}
