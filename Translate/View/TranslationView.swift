import SwiftUI


struct TranslationView: View {
    
    @State private var selectedLanguage: Language = Language(id: "en", name: "English")
    @State private var inputText: String = ""
    @StateObject private var viewModel = TranslationViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section(header: Text("Original")) {
                        TextField("Input text to translate", text: $inputText).padding()
                    }
                    Section(header: Text("Translated")) {
                        Text(viewModel.translatedText).padding()
                    }
                    Section {
                        if viewModel.languages.count > 0 {
                            Picker("Translate to:", selection: $selectedLanguage) {
                                ForEach(viewModel.languages, id: \.self) { language in
                                    Text(language.name)
                                }
                            }
                        }
                        else {
                            Text("Loading languages...").padding()
                        }
                    }.onAppear() {
                        // fetch languages
                        viewModel.fetchAvailableLanguages()
                    }
                }.listStyle(InsetGroupedListStyle())
                
                Button("Translate!", action: translate).padding()
            }
        }
    }
    
    // Note: Some actual text from different language is not being detected by the API
    func translate() {
        // detect language of entered text
        viewModel.detectLanguage(for: inputText, completion: { lan in
            // translate text
            viewModel.translate(
                text: inputText,
                from: lan ?? "en",
                to: selectedLanguage.id)
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TranslationView()
    }
}
