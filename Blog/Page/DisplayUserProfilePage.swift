import LoremSwiftum
import SwiftUI

struct DisplayUserProfilePage: View {
    
    @EnvironmentObject
    private var accountManager: UserAccountManager
    
    @Environment(\.colorScheme)
    private var systemColorScheme
    
    private let user: UserAccount
    
    init(user: UserAccount) {
        self.user = user
    }
    
    private var isOwnAccount: Bool {
        user.id == accountManager.loggedInUser?.id
    }
    
    private func onPressEditButton() {
        
    }
    
    public var body: some View {
        GeometryReader { metrics in
            ZStack {
                ZStack {
                    layerPageBackground
                    NewFollowerCountView(user: user, followers: 0, following: 0)
                        .offset(x: 75, y: -(metrics.size.height*0.56))
                }
                
                ScrollView {
                    ZStack {
                        layerCardBackground
                        layerCardForeground
                            .padding(.horizontal)
                            .padding(.top)
                    }
                }
            }
        }
        .navigationTitle("Profile")
    }
    
    private var layerPageBackground: some View {
        let systemPageBackground = systemColorScheme == .dark ? Color.black : Color.white
        return VStack(spacing: 0) {
            Color.blue.ignoresSafeArea()
            systemPageBackground.ignoresSafeArea()
        }
    }
    
    private var layerCardBackground: some View {
        let bgColor = systemColorScheme == .dark ? Color.black : Color.white
        return bgColor.ignoresSafeArea(edges: [.horizontal, .bottom])
            .frame(height: 1000)
    }
    
    private var layerCardForeground: some View {
        VStack {
            UserProfileHeaderView(user)
            sectionControls
                .padding(.top)
                .padding(.horizontal)
            
            Spacer()
        }
    }
    
    private var sectionControls: some View {
        HStack {
            Spacer()
            
            if isOwnAccount {
                Button("Logout") {
                    accountManager.clearUserForSession()
                }
                Button("Edit") {
                    onPressEditButton()
                }
            }
            
            Button(action: {}) {
                Image(systemName: "square.and.arrow.up")
            }
            
        }
        .buttonStyle(.bordered)
    }
}

#Preview {
    let firstName = LoremSwiftum.Lorem.firstName
    let lastName  = LoremSwiftum.Lorem.lastName
    let biography = LoremSwiftum.Lorem.shortTweet
    let mockUser = UserAccount(
        username: firstName,
        password: "Password",
        biography: biography
    )
    
    mockUser.displayName = "\(firstName)\(lastName)"
    
    return NavigationStack {
        DisplayUserProfilePage(user: mockUser)
    }
    .environmentObject(UserAccountManager())
}