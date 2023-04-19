import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink("Matrix Editor") {
                    MatrixEditorDemoView()
                }
                NavigationLink("Vector Editor") {
                    VectorEditorDemoView()
                }
            }
        }
    }
}
