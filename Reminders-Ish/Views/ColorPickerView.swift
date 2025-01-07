import SwiftUI

struct ColorPickerView: View {
    
    @Binding var selectedColor: Color
    
    private let colors: [Color] = [.red, .green, .blue, .yellow, .orange, .purple]
    
    var body: some View {
        HStack {
            ForEach(colors, id: \.self) { color in
                ZStack {
                    Circle().fill()
                        .foregroundStyle(color)
                        .padding(2)
                    
                    Circle()
                        .strokeBorder(selectedColor.toHex() == color.toHex() ? .gray : .clear, lineWidth: 4)
                        .scaleEffect(CGSize(width: 1.2, height: 1.2))
                }
                .onTapGesture {
                    selectedColor = color
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: 100)
        .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
    }
}

#Preview {
    @Previewable @State var foo: Color = .blue
    
    ColorPickerView(selectedColor: $foo)
}
