// The Swift Programming Language
// https://docs.swift.org/swift-book
import SwiftUI

public struct Control: Identifiable, Hashable {
	var name: String
	var isActive: Bool
	public var id: String {
		self.name
	}
}
public struct MultiSegmentedControl: View {
	let controls: [Binding<Control>]
	var grayscaleWhiteAmount: CGFloat = 0.8
	public var body: some View {
		HStack(spacing: 1) {
			ForEach(controls, id: \.self.wrappedValue) { control in
				SegmentElementView(
					control: control,
					grayscaleWhiteAmount: grayscaleWhiteAmount
				)
			}
		}
		.frame(height: 30)
		.padding(2)
		.background(
			RoundedRectangle(cornerRadius: 8)
				.fill(Color(white: grayscaleWhiteAmount + 0.1))
		)
	}
}

private struct SegmentElementView: View {
	@Binding var control: Control
	let grayscaleWhiteAmount: CGFloat
	var body: some View {
		ZStack {
			RoundedRectangle(cornerRadius: 8)
				.fill(
					color(control.isActive).gradient
						.shadow(shadow(control.isActive))
				)
			Text(control.name)
				.font(.caption2)
				.offset(x: control.isActive ? -1 : 0, y: control.isActive ? -1 : 0)
		}
		.onTapGesture {
			control.isActive.toggle()
		}
	}
	
	private func color(_ isActive: Bool) -> Color {
		isActive ? .init(white: grayscaleWhiteAmount) : .init(white: grayscaleWhiteAmount + 0.1)
	}
	
	private func shadow(_ isActive: Bool) -> ShadowStyle {
		isActive ?
		ShadowStyle.inner(color: .black, radius: 1, x: 1, y: 1) :
		ShadowStyle.drop(color: .black, radius: 1, x: 1, y: 1)
	}
}

struct ButtonPrev: View {
	@State var control1 = Control(name: "Border", isActive: true)
	@State var control2 = Control(name: "Fill", isActive: false)
	var body: some View {
		VStack {
			Capsule()
				.strokeBorder(control1.isActive ? .black : .clear, lineWidth: 10)
				.background(control2.isActive ? .blue : .clear)
				.clipShape(.capsule)
				.frame(width: 200, height: 100)
				
			
			if !control1.isActive && !control2.isActive {
				Text("No option selected")
			}
			MultiSegmentedControl(controls: [$control1, $control2])
				.frame(height: 40)
			
			
		}
	}
}

#Preview {
	VStack {
		ButtonPrev()
	}
		.padding()
}
