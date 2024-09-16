// The Swift Programming Language
// https://docs.swift.org/swift-book
import SwiftUI

public struct Control: Identifiable, Hashable {
	public var name: String
	public var image: Image?
	public var isActive: Bool
	public var id: String {
		self.name
	}
	
	public init(name: String, image: Image? = nil, isActive: Bool = false) {
		self.name = name
		self.isActive = isActive
		self.image = image
	}
	
	public func hash(into hasher: inout Hasher) {
		hasher.combine(name)
		hasher.combine(id)
		hasher.combine(isActive)
	}
}
public struct MultiSegmentedControl: View {
	@Environment (\.colorScheme) var colorScheme
	let controls: [Binding<Control>]
	let grayscaleWhiteAmount: CGFloat
	let isHorizontal: Bool

	var adjustedWhiteColor: CGFloat {
		switch colorScheme {
			case .light:
				return grayscaleWhiteAmount
			case .dark:
				return 0
			@unknown default:
				return grayscaleWhiteAmount
		}
	}
	
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
					grayscaleWhiteAmount: adjustedWhiteColor
				)
			}
		}
		.frame(height: isHorizontal ? CGFloat(30 + spacing) : CGFloat((30 + Int(spacing)) * controls.count))
		.padding(2)
		.background(
			RoundedRectangle(cornerRadius: 8)
				.fill(Color(white: adjustedWhiteColor + 0.1))
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
			HStack {
				Text(control.name)
					.font(.caption2)
				
				if let image = control.image {
					image
						.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(width: 14, height: 14)
				}
			}
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
	@State var control1 = Control(name: "Border", image: Image(systemName: "underline"))
	@State var control2 = Control(name: "Fill", image: Image(systemName: "strikethrough"))
	var body: some View {
		VStack {
			Capsule()
				.strokeBorder(control1.isActive ? .black : .init(white: 0.9), lineWidth: 10)
				.background(control2.isActive ? .blue : .init(white: 0.9))
				.clipShape(.capsule)
			
			if !control1.isActive && !control2.isActive {
				Text("No option selected")
			}
			Spacer()
			VStack(alignment: .leading, spacing: 4) {
				Text("Vertical")
				MultiSegmentedControl(controls: [$control1, $control2], isHorizontal: false)
			}
			VStack(alignment: .leading, spacing: 4) {
				Text("Horizontal")
				MultiSegmentedControl(controls: [$control1, $control2], isHorizontal: true)
			}
		}
		.animation(.easeInOut, value: control1.isActive)
		.animation(.easeInOut, value: control2.isActive)
	}
}

#Preview {
	ButtonPrev()
		.padding()
}
