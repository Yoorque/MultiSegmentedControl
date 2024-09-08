// The Swift Programming Language
// https://docs.swift.org/swift-book
import SwiftUI

public struct Control: Identifiable, Hashable {
	public var name: String
	public var isActive: Bool
	public var id: String {
		self.name
	}
	
	public init(name: String, isActive: Bool = false) {
		self.name = name
		self.isActive = isActive
	}
}
public struct MultiSegmentedControl: View {
	let controls: [Binding<Control>]
	let grayscaleWhiteAmount: CGFloat
	let isHorizontal: Bool

	public init(controls: [Binding<Control>], grayscaleWhiteAmount: CGFloat = 0.8, isHorizontal: Bool = true) {
		self.controls = controls
		self.grayscaleWhiteAmount = grayscaleWhiteAmount
		self.isHorizontal = isHorizontal
	}
	
	public var body: some View {
		let spacing: CGFloat = isHorizontal ? 1 : 2
		let layout = isHorizontal ? AnyLayout(HStackLayout(spacing: spacing)) : AnyLayout(VStackLayout(spacing: spacing))
		layout {
			ForEach(controls, id: \.self.wrappedValue) { control in
				SegmentElementView(
					control: control,
					grayscaleWhiteAmount: grayscaleWhiteAmount
				)
			}
		}
		.frame(height: isHorizontal ? CGFloat(40 + spacing) : CGFloat((40 + Int(spacing)) * controls.count))
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
	@State var control1 = Control(name: "Border")
	@State var control2 = Control(name: "Fill")
	var body: some View {
		VStack {
			Capsule()
				.strokeBorder(control1.isActive ? .black : .clear, lineWidth: 10)
				.background(control2.isActive ? .blue : .clear)
				.clipShape(.capsule)
			
			if !control1.isActive && !control2.isActive {
				Text("No option selected")
			}
			Spacer()
			MultiSegmentedControl(controls: [$control1, $control2], isHorizontal: false)
			MultiSegmentedControl(controls: [$control1, $control2], isHorizontal: true)
		}
	}
}

#Preview {
	ButtonPrev()
		.padding()
}
