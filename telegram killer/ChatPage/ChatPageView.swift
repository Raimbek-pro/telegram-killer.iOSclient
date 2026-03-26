//
//  MainPage.swift
//  telegram killer
//
//  Created by Райымбек Омаров on 02.03.2026.
//

import SwiftUI


struct ChatPageView: View {
    
  
    @StateObject var  viewModel : ChatPageVM
    @State var email = ""
    @State var message = ""
    @State var showScrollButton = false
    @State private var scrollPosition = ScrollPosition(idType: String.self)
    
    @State private var  offset : [String :CGFloat]  = [:]
    
    
    @State private var lastMarkedIndex: Int = -1
    
    init(ChatPageVM : ChatPageVM ){
        self._viewModel = StateObject(wrappedValue: ChatPageVM)
    }
    
    var body: some View {
        
        
        VStack{
            VStack{
                
                HStack{
                    Text(viewModel.usersEmail)
                        .font(.headline)
                        .padding(5)
                        .glassEffect( )
                }
            }
            .padding(.bottom, 20)
            
          
            ZStack{
               
                GeometryReader { geo in
                    let screenWidth = geo.size.width
                
                ScrollView{
                    LazyVStack{
                        chatScroll(screenWidth: screenWidth)
                    }
                    .scrollTargetLayout()
                    .onChange(of: viewModel.messages ) {
                    
                        if let me = viewModel.messages.last?.fromMe {
                            if me {
                                withAnimation{
                                        scrollPosition.scrollTo(id: viewModel.messages.last?.id , anchor : .bottom)
                                }
                            }
                            else {
                                if let dis = distanceFromBottom {
                                    print("dis \(dis)")
                                    if dis <  3 {
                                        withAnimation{
                                            scrollPosition.scrollTo(id: viewModel.messages.last?.id , anchor : .bottom)
                                        }
                                    }
                                    else {
                                        showScrollButton = true
                                    }
                                    
                                }
                            }
                        }
                    }
                    .onChange(of: viewModel.isLoaded){
                        if let las  = viewModel.lastRead {
                            let posAfter =  min((viewModel.messages.firstIndex(where: { $0.id == las}) ?? 0) + 1 , viewModel.messages.count - 1)
                            if las == viewModel.messages.last?.id {
                                scrollPosition.scrollTo(id: viewModel.messages[posAfter].id , anchor : .bottom)
                               
                            } else{
                                scrollPosition.scrollTo(id: viewModel.messages[posAfter].id, anchor: .bottom)
                                
                                Task{
                                    if !viewModel.messages[posAfter].fromMe{
                                     
                                        await viewModel.markAsRead(messageId: viewModel.messages[posAfter].id )
                                    }
                                }
                            }
                          
                        } else {
                            scrollPosition.scrollTo(id: viewModel.messages.last?.id , anchor:  .bottom)
                            if viewModel.messages.last != nil {
                                
                                if !viewModel.messages.last!.fromMe {
                                    
                                    Task{
                                       
                                        await viewModel.markAsRead(messageId: viewModel.messages.last!.id )
                                    }
                                }
                            }
                            
                        }
                        
                    }
                }.scrollPosition($scrollPosition , anchor: .bottom)
                    .onChange(of: scrollPosition){
                        let dis = distanceFromBottom ?? 0
                        showScrollButton = dis > 0
                        var cur = lastElementNow
                        
                      
                        if lastMarkedIndex < cur {
                            let messageAtCur =  viewModel.messages[cur]
                            if !messageAtCur.fromMe{
                                lastMarkedIndex = cur
                                Task{
                                    await viewModel.markAsRead(messageId: viewModel.messages[cur].id )
                                }
                            }
                          
                        }
                        
                    }
                
            }
                    VStack{
                        Spacer()
                        if showScrollButton {
                                scrollButton
                        }
                    }
                }
            
            HStack{
                
              TextField("send message", text: $message)
                    .frame(height: 40)
                    .glassEffect()
                    .padding(20)
                   
                sendMessage
                    
            }
     
        }
        .background(
            LinearGradient(colors: [
                .white.opacity(0.3), .blue.opacity(0.7)
            ], startPoint: .topLeading, endPoint:   .bottomTrailing)
            .ignoresSafeArea()
            )
        
        .task {
        
                 await viewModel.startConnection()
                
        }
        .onDisappear{
            Task{
                try? await viewModel.hub.leaveChat(chatId: viewModel.chatId)
            }
        }

    }
    
    

        
}


extension ChatPageView {
    

    var sendMessage : some View {
        
        Button(action: {
                Task{
                    await  viewModel.sendMessage(to: viewModel.usersChat.chatId, message: message)
                    self.message = ""
                }
        }, label: {
             Image(systemName: "paperplane")
                .foregroundStyle(.white)
                .padding()
                .background(.blue )
                .glassEffect()
                .clipShape(.circle)
        })
        .padding(.horizontal, 3)
    }
  @ViewBuilder
    func chatScroll(screenWidth : CGFloat) -> some View {
        ForEach(viewModel.messages ){ mes in
          
                ZStack(alignment: .leading){
                    Text(FormatDate.formatDate(date: mes.sentAt)?.formatted() ?? "No time")
                        .padding(.horizontal , 10)
                        .fixedSize()
                        .offset(x: (offset[mes.id] ?? 0)+screenWidth)
                    HStack{
                        if mes.fromMe {
                            Spacer()
                        }
                        
                            VStack(alignment: .leading){
                                Text(mes.message)
                                  
                                
                                    .alignmentGuide(.leading, computeValue: { dim in
                                        dim[.trailing]
                                    })
                                
                                if mes.fromMe{
                                    Image(systemName :{
                                        let current = viewModel.messages.firstIndex(where: {$0.id == mes.id}) ?? 0
                                        let last = viewModel.messages.firstIndex(where: {$0.id == viewModel.lastRead}) ?? 0
                                        print("current mes \(mes.id)")
                                        print("last read \(viewModel.lastRead)")
                                        return current <= last ? "checkmark.circle.fill" :  "checkmark.circle"
                                    }())
                                    
                                    .padding(.horizontal , 5)
                                }
                                
                            }
                            
                            .frame(minWidth: 20,  alignment: .leading)
                            .padding()
                           
                            .glassEffect(
                                .clear.interactive(),
                                            in: RoundedRectangle(cornerRadius: 30)
                                        )
                            
                            
                        
                        
                        
                        if !mes.fromMe {
                            Spacer()
                        }
                        
                    }
                    
                    .offset(x: offset[mes.id] ?? 0)
                    .contentShape(Rectangle())
                   .simultaneousGesture(
                
                        DragGesture(minimumDistance: 20)
                            .onChanged{ value in
                                let translation = value.translation.width
                                if translation < 0 {
                                    offset[mes.id] = translation
                                }
                            }.onEnded{_ in
                                withAnimation(.bouncy){
                                
                                    offset[mes.id] = 0
                                }
                            }
                    
                    )
                }
                .id(mes.id)
            
                
            
         
            
        }
    }
    var scrollButton : some View {
  
            
            Button(action: {
                
                scrollPosition.scrollTo(id: viewModel.messages.last?.id , anchor : .bottom)
                    showScrollButton = false
                
                

            }, label: {
                Image(systemName: "arrow.down")
                    .foregroundStyle(.gray)
                    .padding()
                    .glassEffect()
                    .clipShape(.circle)
            })
        
    }
    
    var distanceFromBottom : Int? {
        guard
        let currentID =  scrollPosition.viewID(type: String.self),
        let currentIndex = viewModel.messages.firstIndex(where: { $0.id == currentID}),
        let lastIndex = viewModel.messages.indices.last
            
        else {print("why")
            return nil }
        
        let rawDistance = lastIndex -  currentIndex
        
        return max(0,rawDistance)
    }
    
    var lastElementNow : Int {
        guard
        let currentID =  scrollPosition.viewID(type: String.self),
         let currentIndex = (viewModel.messages.firstIndex(where: { $0.id ==  currentID}))
        else {print("not long enough")
            return 0 }

       return currentIndex
        
    }
    
   
 
}



#Preview {
    ChatPageView(ChatPageVM: ChatPageVM.preview())
}
