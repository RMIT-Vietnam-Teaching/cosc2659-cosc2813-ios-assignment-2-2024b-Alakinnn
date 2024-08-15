import SwiftUI

struct CharacterBody2D: View {
    let offsetValue: CGFloat
    let width: CGFloat
    let height: CGFloat
    var vm: GameViewModel
    var index: Int // Pass the index instead of the enemy

    var body: some View {
        ZStack {
            Image(systemName: "person.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: width, height: height)
                .offset(y: offsetValue)
          
            Rectangle()
                .fill(Color.black.opacity(0.001))
                .frame(width: width * 0.8, height: height * 0.6)
                .border(Color.red, width: 2)
                .offset(y: offsetValue)
                .onTapGesture {
                    vm.stageViewModel.applyCardToEnemy(at: index)
                }
        }
    }
}

#Preview {
    CharacterBody2D(offsetValue: 0, width: 100, height: 200, vm: GameViewModel(), index: 0)
}
