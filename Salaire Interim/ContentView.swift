import SwiftUI

struct ContentView: View {
    @State private var heures: String = ""
    @State private var salaireEstime: Double = 0.0
    @State private var salaireNet: Double = 0.0
    @FocusState private var isFocused: Bool
    
    let tauxHoraireNormal: Double = 11.65
    let tauxHoraireSupplementaire: Double = 14.56
    let tauxHoraireSupplementairePlus: Double = 17.475
    
    var day: String {
        let calendrier = Calendar.current.component(.weekday, from: Date())
        switch calendrier {
        case 1:
            return "Dimanche"
        case 2:
            return "Lundi"
        case 3:
            return "Mardi"
        case 4:
            return "Mercredi"
        case 5:
            return "Jeudi"
        case 6:
            return "Vendredi"
        case 7:
            return "Samedi"
        default:
            return "Erreur avec la récupération de la date"
        }
    }
    
    func estimatePrix() {
        isFocused = false
        let heuresFormatted = heures.replacingOccurrences(of: ",", with: ".")
        if var heuresDouble = Double(heuresFormatted) {
            var salaire = 0.0
            if heuresDouble >= 35 {
                salaire += 35 * tauxHoraireNormal
                heuresDouble -= 35
                if heuresDouble >= 8 {
                    salaire += 8 * tauxHoraireSupplementaire
                    heuresDouble -= 8
                    if heuresDouble > 0 {
                        salaire += heuresDouble * tauxHoraireSupplementairePlus
                    }
                } else {
                    salaire += heuresDouble * tauxHoraireSupplementaire
                }
            } else {
                salaire = heuresDouble * tauxHoraireNormal
            }
            salaire *= 1.10 // IFM
            salaire *= 1.10 // Indemnite congé payer
            salaireEstime = salaire
            salaireNet = salaireEstime * 0.795 // Environ 20,5 % de cotisation
        } else {
            print("Erreur : L'entrée n'est pas un nombre valide")
        }
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack {
                Text("Entrez votre nombre d'heures fait sur la semaine")
                    .multilineTextAlignment(.center)
                    .frame(width: 300)
                
                TextField("", text: $heures)
                    .padding()
                    .frame(width: 280)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.decimalPad)
                    .focused($isFocused)
                
                Button(action: estimatePrix) {
                    Text("Lancez mon estimation")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                if salaireEstime != 0 {
                    VStack(spacing: 10) {
                        HStack {
                            Text("Salaire Brut estimé : ")
                            Text("\(salaireEstime, specifier: "%.2f") €").bold()
                        }
                        .padding()
                        
                        if salaireNet != 0 {
                            VStack {
                                HStack {
                                    Text("Salaire Net estimé :")
                                    Text("\(salaireNet, specifier: "%.2f") €")
                                        .bold()
                                }
                                Text("les cotisations changent en fonction de plusieurs paramètres, la marge d'erreur est plus élevée (~ 3%)")
                                    .font(.system(size: 10))
                                    .multilineTextAlignment(.center)
                                    .padding(.top)
                                    .foregroundColor(Color.gray)
                                    .frame(width: 300)
                            }
                        }
                    }
                }
            }
            Spacer()
            
            Text("Développé par Lucas Fernandes")
                .font(.footnote)
                .foregroundColor(.gray)
                .padding(.bottom, 25)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
