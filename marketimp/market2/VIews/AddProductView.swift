import SwiftUI

struct AddProductView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dataManager: DataManager
    
    @State private var title = ""
    @State private var description = ""
    @State private var price = ""
    @State private var category = "Электроника"
    @State private var condition = "Отличное"
    @State private var location = ""
    @State private var images: [UIImage] = []
    @State private var showingImagePicker = false
    
    let categories = ["Электроника", "Одежда и обувь", "Книги", "Спорт и отдых", "Мебель", "Другое"]
    let conditions = ["Новое", "Отличное", "Хорошее", "Удовлетворительное"]
    
    var body: some View {
        NavigationView {
            Form {
                // Секция с основной информацией
                Section(header: Text("Информация о товаре")) {
                    TextField("Название", text: $title)
                    
                    TextField("Цена", text: $price)
                        .keyboardType(.decimalPad)
                    
                    Picker("Категория", selection: $category) {
                        ForEach(categories, id: \.self) {
                            Text($0)
                        }
                    }
                    
                    Picker("Состояние", selection: $condition) {
                        ForEach(conditions, id: \.self) {
                            Text($0)
                        }
                    }
                    
                    TextField("Местоположение", text: $location)
                    
                    VStack(alignment: .leading) {
                        Text("Описание")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        TextEditor(text: $description)
                            .frame(minHeight: 100)
                    }
                }
                
                // Секция с фотографиями
                Section(header: Text("Фотографии")) {
                    Button(action: {
                        showingImagePicker = true
                    }) {
                        HStack {
                            Image(systemName: "photo")
                            Text("Добавить фотографии")
                        }
                    }
                    
                    // Отображение выбранных изображений
                    if !images.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(0..<images.count, id: \.self) { index in
                                    Image(uiImage: images[index])
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .overlay(
                                            Button(action: {
                                                images.remove(at: index)
                                            }) {
                                                Image(systemName: "xmark.circle.fill")
                                                    .foregroundColor(.white)
                                                    .background(Color.black.opacity(0.7))
                                                    .clipShape(Circle())
                                            }
                                            .padding(5),
                                            alignment: .topTrailing
                                        )
                                }
                            }
                        }
                        .frame(height: 120)
                    }
                }
                
                // Кнопка добавления товара
                Section {
                    Button(action: {
                        addProduct()
                    }) {
                        Text("Добавить товар")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                            .padding()
                            .background(isFormValid ? Color.blue : Color.gray)
                            .cornerRadius(10)
                    }
                    .disabled(!isFormValid)
                }
            }
            .navigationTitle("Добавить товар")
            .navigationBarItems(trailing: Button("Отмена") {
                presentationMode.wrappedValue.dismiss()
            })
            .sheet(isPresented: $showingImagePicker) {
                // Здесь будет ImagePicker для выбора изображений
                // В реальном приложении вы бы использовали UIViewControllerRepresentable для UIImagePickerController
                // Для простоты мы используем заглушку
                Text("Здесь будет выбор изображений")
                    .padding()
                    .onTapGesture {
                        // Добавляем тестовое изображение
                        let image = UIImage(systemName: "photo") ?? UIImage()
                        images.append(image)
                        showingImagePicker = false
                    }
            }
        }
    }
    
    // Проверка валидности формы
    private var isFormValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !price.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !location.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    // Добавление нового товара
    private func addProduct() {
        guard let priceValue = Double(price),
              let currentUser = dataManager.userProfile else {
            return
        }
        
        // Создаем новый товар
        let newProduct = Product(
            id: UUID().uuidString,
            sellerId: currentUser.id,
            title: title,
            description: description,
            price: priceValue,
            category: category,
            condition: condition,
            location: location,
            imageURLs: [], // В реальном приложении здесь будут URL загруженных изображений
            status: .active,
            createdAt: Date()
        )
        
        // Добавляем товар в список
        dataManager.addProduct(newProduct)
        
        // Закрываем экран
        presentationMode.wrappedValue.dismiss()
    }
}
