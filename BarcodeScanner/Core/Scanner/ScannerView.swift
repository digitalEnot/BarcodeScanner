//
//  ScannerView.swift
//  BarcodeScanner
//
//  Created by Evgeni Novik on 19.10.2025.
//

import SwiftUI

struct ScannerView: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject var vm = ScannerViewModel()
    @State private var path = NavigationPath() // не переместить ли на уровень ниже???
    
    var body: some View {
        NavigationStack(path: $path) {
            GeometryReader { geometry in
                ZStack {
                    CameraVCRepresentable(isFlashOn: $vm.isFlashOn, error: $vm.error, scannedCode: $vm.scannedCode, rectOfInterest: $vm.rectOfInterest, codeType: $vm.codeType, path: $path)
                    
                    if let rect = vm.rectOfInterest {
                        RectOfInterest(minX: rect.minX, minY: rect.minY, midX: rect.midX, midY: rect.midY, width: rect.width, height: rect.height, backgoundLenght: 40)
                    } else {
                        let size: CGFloat = geometry.size.width - 90
                        let x: CGFloat = (geometry.size.width - size) / 2
                        let y: CGFloat = (geometry.size.height - size) / 2
                        let midX: CGFloat = size / 2 + x
                        let midY: CGFloat = size / 2 + y
                        RectOfInterest(minX: x, minY: y, midX: midX, midY: midY, width: size, height: size, backgoundLenght: 40)
                    }
                    
                    flashlight
                }
            }
            .navigationDestination(for: String.self) { selection in
                if selection == "EditCodeName" {
                    EditCodeNameView(scannedCode: vm.scannedCode, dismiss: dismiss, codeType: vm.codeType)
                }
            }
            .ignoresSafeArea()
        }
    }
    
    var flashlight: some View {
        Button {
            vm.isFlashOn.toggle()
        } label: {
            Image(systemName: vm.isFlashOn ? "flashlight.on.circle.fill" : "flashlight.off.circle.fill")
                
        }
        .font(.custom("flash", size: 50))
        .foregroundStyle(vm.isFlashOn ? Color.white : Color.gray)
        .offset(y: 250)
    }
}

private struct RectOfInterest: View {
    let minX: CGFloat
    let minY: CGFloat
    let midX: CGFloat
    let midY: CGFloat
    let width: CGFloat
    let height: CGFloat
    
    let backgoundLenght: CGFloat
    var halfWidth: CGFloat { (width - backgoundLenght) / 2 }
    var halfHeght: CGFloat { (height - backgoundLenght) / 2 }
    
    var body: some View {
        CustomShape(x: minX, y: minY, height: height, width: width)
            .fill(Color.black.opacity(0.7))
        corner(x: midX - halfWidth, y: midY - halfHeght, degrees: 0)
        corner(x: midX + halfWidth, y: midY - halfHeght, degrees: 90)
        corner(x: midX + halfWidth, y: midY + halfHeght, degrees: 180)
        corner(x: midX - halfWidth, y: midY + halfHeght, degrees: 270)
    }
    
    func corner(x: CGFloat, y: CGFloat, degrees: Double) -> some View {
        Color.clear
            .frame(width: backgoundLenght, height: backgoundLenght)
            .overlay {
                RoundedAngels()
                    .rotation(Angle(degrees: degrees))
                    .stroke(Color.white, lineWidth: 6)
            }
            .position(x: x, y: y)
    }
}

private struct RoundedAngels: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 30))
        path.addCurve(
            to: CGPoint(x: 30, y: 0),
            control1: CGPoint(x: 0, y: -5),
            control2: CGPoint(x: -5, y: 0)
        )
        
        return path.strokedPath(.init(lineCap: .round))
    }
}

private struct CustomShape: Shape {
    let x: CGFloat
    let y: CGFloat
    let height: CGFloat
    let width: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: x + width, y: rect.height))
        path.addLine(to: CGPoint(x: x + width, y: y))
        path.addLine(to: CGPoint(x: x, y: y))
        path.addLine(to: CGPoint(x: x, y: y + height))
        path.addLine(to: CGPoint(x: x + width, y: y + height))
        path.addLine(to: CGPoint(x: x + width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        
        return path
    }
}

#Preview {
    ScannerView()
}
