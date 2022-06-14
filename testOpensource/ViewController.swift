import UIKit
import AmitySDK
import AmityUIKit
import Foundation
import SwiftUI
class ViewController: UIViewController {
    let client = try! AmityClient(apiKey: "b3babb0b3a89f4341d31dc1a01091edcd70f8de7b23d697f", region: .SG)
    override func viewDidLoad() {
        super.viewDidLoad()


        /// Amity repository should declare only one time
        postRepository = AmityPostRepository(client: client)
        messageRepository = AmityMessageRepository(client:client)
        channelRepository = AmityChannelRepository(client: client)
        userRepository = AmityUserRepository(client: client)
        communityRepository = AmityCommunityRepository(client: client)
        commentRepo = AmityCommentRepository(client: client)
        userRepository = AmityUserRepository(client: client)
        membershipParticipation = AmityChannelParticipation(client: client, andChannel: "channel1")
        feedRepository = AmityFeedRepository(client: client)
        pollRepository = AmityPollRepository(client: client)
        messageReactor = AmityReactionRepository(client: client)
        fileRepository = AmityFileRepository(client: client)

    }
    var messageReactor : AmityReactionRepository?
    var communityID:String = "45caae5586372066736a3234df34df50"
    
    var fileRepository : AmityFileRepository?
    /// Login Button
    @IBAction func LoginButton(_ sender: Any) {
       login(userID: "johnwick2",displayName: "johnwick2")
 // AmityUIKitManager.registerDevice(withUserId: "johnwick2", displayName: "johnwick2")
    }
    /// Create community channel button
    @IBAction func createCommunityButton(_ sender: Any) {
        // 1.
        // Register your cell here. You can register both
        // nib as well as class itself.
        AmityFeedUISettings.shared.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "customcell1")
        AmityFeedUISettings.shared.dataSource = self

        // Showing our feed UI
        let feedViewController = AmityChatHomePageViewController.make()
        
        self.navigationController?.pushViewController(feedViewController, animated: true)
    


    }

    @IBAction func addMemberButton(_ sender: Any) {
 
       createConversationChannel(chanelID: "Woohoo", listOfUserID: ["johnwick2","auTest2"], channelName: "johnwick2-auTest2")
    }
    /// Send text button
    @IBAction func sendText(_ sender: Any) {
        
        let vc = AmityPostTargetPickerViewController.make(postContentType: .post)
      guard let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else { return  }
          
          let navController = UINavigationController(rootViewController: vc)
          
          navController.modalPresentationStyle = .fullScreen
          
          window.rootViewController = navController
        let url = URL(string: "creaturlpost://")

        UIApplication.shared.open(url!) { (result) in
            if result {
               // The URL was delivered successfully!
            }
        }
            }

    /// button for observe message within channel
    @IBAction func observeChannel(_ sender: Any) {
        postQueryExample();
//        quryCommunityChannel()
//        updateChannelMetadata()
//        joinChannel(channelId: "6273dc8053c74600daf4ba9f")
//        queryMessage(channelId: "6273dc8053c74600daf4ba9f")
//        joinChannel(channelId: "talkofthecloudQ3")
//        queryMessage(channelId: "talkofthecloudQ3")
//        postQueryExample2())
//        openLiveVC(targetID: "621e043a4b898f00d9008f9d", targetType: .community, destinationToUnwindBackAfterFinish: self)
//        let viewController = AmityChatHomePageViewController.make()
//
//
//        // present
//        let navigationController = UINavigationController(rootViewController: viewController)
//        present(navigationController, animated: true, completion: nil)
    }

 


    func addReaction(messageId:String){
        print("add")

        messageReactor?.addReaction("love", referenceId: messageId, referenceType: .message) { (success, error) in
            print("adding")
            if let error = error {
                print(error)
            }
            else{
                print("add success")
            }
        }
    }
    
    func updateChannelMetadata(id: String){
        let builder = AmityChannelUpdateBuilder(channelId: id)
         builder.setMetadata(["key": "value"])
        token = channelRepository?.updateChannel(with: builder).observe { channel, error in
            if let error = error {
                print(error)
            }
            else{
                print("success")
            }
           }
    }
    
    
    
    func removeReaction(messageID:String){
        print("remove")
      
        messageReactor?.removeReaction("love", referenceId: messageID, referenceType: .message) {(success, error) in
            print("removing")
            if let error = error {
                print(error)
            }
            else{
                print("remove success")
            }
        }
    }
    

                                                    
    func joinChannel(channelId: String) {
        
        // Join a channel by start observing the live object.
        token = channelRepository?.joinChannel(channelId).observe { liveObject, error in
            if let error = error {
                print(error)
                return
            }
            guard let channel = liveObject.object else {
                return
            }
            print("Sucessfully join a channel: \(channel.channelId)")
        }
    }
    func postQueryExample() {
       
        print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
        let feedCollection = feedRepository?.getCommunityFeed(
              withCommunityId: "624593fb40222100d9d3c314",
              sortBy: .lastCreated,
              includeDeleted: false,
              feedType: .published
        )
   
        token = feedCollection?.observe { collection, change, error in
            if collection.loadingStatus == .loading{
                print("loading")
            }
            if collection.loadingStatus == .loaded {
                if let error = error {
                    print(error)
                }
                else{
                    for i in 0..<collection.count(){
                        let post = collection.object(at: i)
                        
                        print(post?.getPollInfo()?.voteCount)
                    }
            }
            }
          }
    }
    func postQueryExample2() {
        print("run postQueryExample2" )
        // In this example, we will query posts to build user's media gallery.
        // This gallery shows the feed; specifically "image" and "video".
        //
        // 1. Create AmityPostQueryOptions
        // For this use-case:
        // - Search all the "image" and "video" posts
        // - Belong to a user, for example "steven".
        // - Only non-deleted posts.
        // - Sorted by last created.
        let options = AmityPostQueryOptions(
            targetType: .community,
            targetId: "8bf278c954cdbdbe44908865e6b51217",
            sortBy: .lastCreated,
            deletedOption: .notDeleted,
            filterPostTypes: nil
        )
    
        // 2. query the posts, and handle the results via the live collection.
        token = postRepository?.getPosts(options).observe { collection, changes, error in
          
            // Observe the live collection changes here.
            if let error = error {
                print(error)
            }
            else{
                
                if  (collection.loadingStatus == .loaded){
               
                    
                print("success")
                print(collection.count())
                var pollIDList:[String] = []
                for i in 0..<collection.count(){
                    if collection.hasNext {
                        collection.nextPage()
                    }else{
              
                    let post = collection.object(at: i)
                        let poll = post?.getPollInfo()
                        print(post?.data?["text"] )
                        print("pollID: \(String(describing: poll?.pollId))")
                        print(post?.postId ?? "No postID")
                        if (post?.getPollInfo() != nil){
//                            print("\(String(describing: post?.dataType))--\(post?.postId)")
                        let pollID = post!.postId
                        
                            pollIDList.append(pollID)
                          
    
                    }}
            
                }
                   print(pollIDList)
                }}
            
        }
    }
    
   

    func queryCommunityPost(withId id: String) {
        let communityRepository = AmityCommunityRepository(client: AmityUIKitManager.client)
           let collection = communityRepository.getCommunity(withId: id) // REPLACE COMMUNITY_ID WITH YOUR COMMUNITY ID
        token = collection.observe { (community, error) in
            print("check community \(collection.object?.avatar?.fileURL ?? "no value")")
           }

       }
    /// First, Create Amity client

    /// Repository have to declare in class level
    var postRepository: AmityPostRepository?
    var channelRepository:AmityChannelRepository?
    var messageRepository:AmityMessageRepository?
    var membershipParticipation: AmityChannelParticipation?
    /// To observe amity object use AmityNotificationToken
    var community: AmityCommunity?
    var token: AmityNotificationToken?
    var token2: AmityNotificationToken?
    var subscribeCommunityToken: AmityNotificationToken?
    var messageObserver: AmityNotificationToken?
    var chanelObserver: AmityNotificationToken?
    var userRepository: AmityUserRepository?
    var userCollectionToken: AmityNotificationToken?
    var communityRepository: AmityCommunityRepository?
    var commentRepo: AmityCommentRepository?
    var feedRepository: AmityFeedRepository?
    var pollRepository : AmityPollRepository?
    //follow


    var subscriptionManager: AmityTopicSubscription?
    var followerManager: AmityUserFollowManager?

    private var liveCollection: AmityCollection<AmityFollowRelationship>?




//    func registerDeviceTogetPushnotification()
//         if let deviceToken = UserDefaults.standard.value(forKey: "deviceToken") as? String {
//             AmityUIKitManager.unregisterDevicePushNotification()
//             NSLog("Register for push notification")
//             AmityUIKitManager.registerDeviceForPushNotification(deviceToken)
//         }
//     }
    //// To create user or login to existing user

    func login(userID: String,displayName: String){


        client.login(userId: userID, displayName: nil, authToken: nil) { isSuccess, error in
            if let error = error {
                print("error: \(error.localizedDescription)")
            }
            else{
                print("login success")
            }
        }

    }

//    func openLiveVC(targetID: String,targetType: AmityPostTargetType,destinationToUnwindBackAfterFinish:UIViewController){
//
//        let broadcastVC =
//        LiveStreamBroadcastViewController.init
//        broadcastVC.destinationToUnwindBackAfterFinish = destinationToUnwindBackAfterFinish
//        present(broadcastVC, animated: true) {
//
//        }
//    }

    func getCommunity(communityId: String) {
        token = communityRepository?.getCommunity(withId: communityId).observe { liveObject, error in
            if let error = error {
                print(error)
                return
            }
            guard let community = liveObject.object else {
                return
            }
            // Handle the result here...
            print(community)
        }
    }




    func deleteMessage(byId id: String) {

        messageRepository?.deleteMessage(withId: id, completion: { (success, error) in
            print(success)
            if let error = error {
                print(error)
            }
            else{
                print("success")
            }
            })
        }

    func followUser(userId:String){
        let start = CFAbsoluteTimeGetCurrent()

        let followManager = userRepository?.followManager
        followManager?
            .followUser(withUserId: userId) { (success, followResponse, error) in
                if let followResponse = followResponse {

                    let diff = CFAbsoluteTimeGetCurrent() - start
                    print("follow \(followResponse.targetUserId): "+"\(diff)")
                } else {
                    print("error following user\(userId): \(String(describing: error))")
            }
        }
    }

    func getUserDetail(userID:String){
        let userObject = userRepository?.getUser(userID)
        userObject?.observe { (user, error) in
            if let error = error{
                print(error)
            }
            else{
                print(user)
            }
        }
    }

    func unfollowUser(userId:String){
        let start = CFAbsoluteTimeGetCurrent()
        let followManager = userRepository?.followManager
        followManager?
            .unfollowUser(withUserId: userId) { (success, followResponse, error) in
                if let followResponse = followResponse {
                    // handle follow info here
                    let diff = CFAbsoluteTimeGetCurrent() - start
                    print("Unfollow \(followResponse.targetUserId): "+"\(diff)")
                } else {
                    print("error unfollowing user\(userId): \(String(describing: error))")
            }
        }
    }

    func deleteComment(withId: String, ishardDelete:Bool ){
        commentRepo?.deleteComment(withId: withId, hardDelete: ishardDelete, completion: { isSuccess, error in

                if let error = error{
                    print(error)
                }
                else{
                    print("delete comment Success:")
                }
        }
        )
    }

    func quryCommunityChannel(){
        
        let query = AmityChannelQuery()
   
        query.filter = .all
//        query.types = [AmityChannelQueryType.community,AmityChannelQueryType.conversation,AmityChannelQueryType.broadcast,AmityChannelQueryType.standard,AmityChannelQueryType.live]
         query.includeDeleted = false
//
       

        token = channelRepository?.getChannels(with: query).observe { collection, error,arg  in
            print("converstaion: \(AmityChannelType.conversation.rawValue)")
            print("commu: \(AmityChannelType.community.rawValue)")
            print("standard: \(AmityChannelType.standard.rawValue)")
            if let error = error {
                print(error)
            }
            else{
                print("count: \(collection.count())")
                print("query channel status: success")
                for i in collection.allObjects(){
//                                    print(collection.count())
                    
                    if i.isDeleted{
                        print("\(i.channelId ): isDeleted: \(i.isDeleted)")
                        
                        print("\(i.channelId ): isDeleted: \(i.isDeleted) type:\(i.channelType)")
                        
                    }
                                    else{
//                                        print("[Not Delete]\(i.channelId )")
//
//                                        print("\(i.channelId ): isDeleted: \(i.isDeleted) type:\(i.channelType)")
//
                                    }
                    
                }

            }
        }
    }

    func createCommunity( displayName: String, members : [String]){
        let builder = AmityCommunityCreationDataBuilder()
        builder.setDisplayName(displayName)
        builder.setUserIds(members)

        builder.setCommunityDescription("For testing")
        builder.setIsPublic(false)
        builder.setMetadata(["test": "test-content"])

        communityRepository?.createCommunity(with: builder, completion: { (liveObject, error) in
            if let error = error {
                print(error)
            }else{
                print("create community : success")
            }
        })
    }


    ////To create community channel
    func createCommunityChannel(chanelID:String, listOfUserID:[String],channelName:String) {


        let builder = AmityCommunityChannelBuilder()
        builder.setId(chanelID)
        builder.setUserIds(listOfUserID)
        builder.setDisplayName(channelName)
        builder.setTags(["01-02"])
        builder.setMetadata(["sdk_type": "ios"])

        let channelObject = channelRepository?.createChannel(with: builder)

        chanelObserver = channelObject?.observe { channelObject, error in
            if let error = error{
                print(error)
            }
            else{

                print("create channel status: success")
            }
        }


    }

    ////To create converstion channel
    func createConversationChannel(chanelID:String, listOfUserID:[String],channelName:String) {


        let builder = AmityConversationChannelBuilder()

        builder.setUserIds(listOfUserID)
        builder.setDisplayName(channelName)
        builder.setTags(["ch-asdasdasd", "ios-sdk"])
        builder.setMetadata(["sdk_type": "ios"])

        let channelObject = channelRepository?.createChannel(with: builder)

        chanelObserver = channelObject?.observe { channelObject, error in
            if let error = error{
                print(error)
            }
            else{

                print("create channel status: success channelID: \(channelObject.object?.channelId ?? "no channelID")")
                print("create channel status: success member: \(String(describing: channelObject.object?.memberCount) ?? "no channelID")")
                print(  AmityChannelType.conversation.rawValue)
                print("create channel status: success type: \(String(describing: channelObject.object?.channelType.rawValue) ?? "no channelID")")
            }
        }


    }

    //b9b0d98591273fd940e0acf531dee414


    ////To observe massage within channel
    func observeChannel(channelID: String){

        let messagesCollection: AmityCollection<AmityMessage> = (messageRepository?.getMessages(channelId: channelID, includingTags: [], excludingTags: [], filterByParentId: false, parentId: nil, reverse: false))!

        self.messageObserver = messagesCollection.observe { collection, change, error in
            if let error = error{
                print(error)
            }
            else{
                
                for index in 0..<collection.count() {

                    if let message = collection.object(at: index), let messageBody =  message.data?["text"] as?  String {
                        print(messageBody)

                    }

                }

                self.messageObserver = nil


            }

        }

    }
    ////To add member into a channel
    func addMemberToChannel(channelID:String,userId:String){

        let participation = AmityChannelParticipation(client: client, andChannel: channelID)
        participation.addMembers([userId]) { isSuccess, error in
            if let error = error {
                print("Add member status : fale error: \(error)")
            }
            else{
                print("Add member status : success")

            }

        }


    }

    //// To send text message within channel
    func sendText(channelID:String,text:String){

        messageRepository?.createTextMessage(withChannelId: channelID, text: text, tags: [], parentId: nil) { message, error in
            if let _error = error{
                print("error:\(_error)")

            }
            else{
                print("send Text status: success")

            }
        }



    }


    ///page1


    var memberNotification: AmityNotificationToken?  // AmityNotificationToken MUST BE DECLARED ON CLASS LEVEL ONLY
    var getChannelNotification: AmityNotificationToken? // AmityNotificationToken MUST BE DECLARED ON CLASS LEVEL ONLY


    func queryCommunityChannel(withID channelID:String) { // query community channel and get channel's display name & avatar url
            var displayName = ""
            var avatarURL = ""
            let communityChannel = channelRepository?.getChannel(channelID) // REPLACE <CHANNEL_ID> WITH YOUR CHANNEL ID

            getChannelNotification = communityChannel?.observe { liveChannel, error in
                if let name = liveChannel.object?.displayName {
                    displayName = name
                }
                if let url = liveChannel.object?.getAvatarInfo()?.fileURL {
                    avatarURL = url
                }


                print("check name and avatar \(displayName) \(avatarURL)")
            }
        }


    func queryConversationChannel(withID channelID:String) { // Query conversation channel and get other user display name & avatar url
              var otherUserDisplayName = ""
              var avatarURL = ""

              let channelParticipation = AmityChannelParticipation(client: client, andChannel: channelID) // REPLACE CHANNEL_ID WITH YOUR CHANNEL ID
              let membershipParticipation = channelParticipation.getMembers(filter: .all, sortBy: .firstCreated, roles:[])

              memberNotification = membershipParticipation.observe{ (collection, change, error) in
                  for i in 0..<collection.count(){
                      if collection.object(at: UInt(i))?.userId != AmityUIKitManager.client.currentUserId {
                          if let name = collection.object(at: UInt(i))?.displayName {
                              otherUserDisplayName = name
                          }
                          if let url = collection.object(at: UInt(i))?.user?.getAvatarInfo()?.fileURL {
                              avatarURL = url
                          }
                          break
                      }

                  }
                  print("check name and avatar \(otherUserDisplayName) \(avatarURL)")
              }

          }


  func queryMessage(channelId: String){
      let messagesCollection: AmityCollection<AmityMessage> = (messageRepository?.getMessages(channelId:channelId, includingTags: [], excludingTags: [], filterByParentId: false, parentId: nil, reverse: false))!
      

          // REPLACE <CHANNEL_ID> WITH YOUR CHANNEL ID
          token = messagesCollection.observe { collection, change, error in

            // refresh tableview with latest message data
    
              if let error = error {print(error)
                  print("error")
              }else{
                  if collection.loadingStatus == .loading {
                      print("loading")
                  }
                  if collection.loadingStatus == .loaded {
                      print("loaded")
                  }
                  print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
                  for i in 0..<collection.count(){
                      print(collection.object(at: i)?.messageId)
              }
                  print("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<,<<<<<<<")
              }
          }
      }


    
    func testFunc (){
        let query = AmityChannelQuery()
        query.filter = .all
        query.types = [AmityChannelQueryType.community]
        token = channelRepository?.getChannels(with: query).observeOnce({ chanelCollection,change, error in
            
            if let error = error{
                print(error)
            }
            else{
                print("total count \(chanelCollection.count())")
                for index in 0 ..< chanelCollection.count() {
                    print("collectionID :\(chanelCollection.object(at: index)?.channelId)")
                    let channel = chanelCollection.object(at: UInt(index))
                    self.token2 = self.messageRepository?.getMessages(
                        channelId: channel!.channelId,
                                includingTags: [],
                                excludingTags: [],
                                filterByParentId: false,
                                parentId: nil,
                                reverse: true
                    ).observe({ collection, change, error in
                        
                        if let error = error {
                            print(error)
                        }
                        else{
                          
                            for index in 0 ..< collection.count(){
                                print( collection.object(at: index)?.data?["text"]!)
                            }
                        }
                    })
                 
                        
            }
            };})


      
    }
    
    

    func loadDisplayData(channelId: String,parentId: String){
        let messagesCollection: AmityCollection<AmityMessage> = (messageRepository?.getMessages(channelId: channelId, includingTags: [], excludingTags: [], filterByParentId: false, parentId: parentId, reverse: false))!

        token = messagesCollection.observe { collection, change, error in

          // refresh tableview with latest message data

            if let error = error {print(error)
                print("error")
            }else{


                //// get all message
                for i in 0..<collection.count(){
                if let messageObject = collection.object(at: i) {
                    ////message text
                    print(messageObject.data!["text"] ?? "no value")
                    ////parent user name
                    print(messageObject.user?.displayName ?? "no value")
                    ///parrent user avatarURL
                    print(messageObject.user?.getAvatarInfo()?.fileURL ?? "no value")
                    ///message timestamp
                    print(messageObject.createdAtDate)

                }
            }
            }
        }
    }




    func sendMessage(channelId: String, text:String) {
        messageRepository?.createTextMessage(withChannelId: channelId, text: text, tags: nil, parentId: nil, completion: { message, error in
            if message != nil {
                   print("The message is created on the server.")
               } else {
                   print("Error: \(error).")
               }
        })

    }

    let channelParticipation = AmityChannelParticipation(client: AmityUIKitManager.client, andChannel: "johnwick2-victimIOS") //REPLACE <CHANNEL_ID> WITH YOUR CHANNEL ID


    func addUser(userIDList: [String]) {
           channelParticipation.addMembers(userIDList) { isSuccess, error in // REPLACE USER_ID WITH YOUR USER ID
                if let error = error {
                    print(error)
                }            else{
                    print("isSuccess:\(isSuccess)")
                }

            }
        }

    func removeUser(userIDList:[String]) {
        channelParticipation.removeMembers(userIDList) { isSuccess, error in
            if let error = error {
                print(error)
            }
            else{
                print("isSuccess:\(isSuccess)")
            }
        }
        }
}



//////// PAGE 1
///



class CustomTableViewCell: UITableViewCell {
    @IBOutlet weak var postText: UITextView!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var contentImage: UIImageView!
    @IBOutlet weak var contentString: UITextView!
    @IBOutlet weak var diplayName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


class MyPostHeaderCell: UITableViewCell {
    // ...
}

class MyCustomPostComponent: AmityPostComposable {
    var token: AmityNotificationToken?
    var post: AmityPostModel
    var postRepo = AmityPostRepository(client: AmityUIKitManager.client)
    var diplayName:String?
//    var contentString:String = "default value"
    var url:String?

    // Post data model which you can use to render ui.
    required init(post: AmityPostModel) {
        self.post = post
 
    }
    
    
    
    func getComponentCount(for index: Int) -> Int {
        return 3
    }
    
    func getComponentCell(_ tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: AmityPostHeaderTableViewCell.cellIdentifier, for: indexPath) as! AmityPostHeaderTableViewCell
                     // ... populate cell data here
            cell.display(post: self.post)
                     return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "customcell1", for: indexPath) as! CustomTableViewCell
            
//            cell.contentString.text = self.post.data["text"] as! String
            cell.diplayName.text = self.post.postedUser?.displayName
            cell.postText.text = (self.post.data["text"] as! String)
            cell.diplayName.text = self.diplayName
            cell.contentString.text = "asdasd"
            let url = URL(string: self.url ?? "https://sitechecker.pro/wp-content/uploads/2017/12/URL-meaning.png")
            
               // Fetch Image Data
            if let data = try? Data(contentsOf: url!) {
                   // Create Image and Update Image View
                   cell.avatarImage.image = UIImage(data: data)
                 
               }
            self.token = postRepo.getPostForPostId(self.post.postId).observeOnce({ object, error in
                print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>.")
                if let error = error {
                    print(error)
                }
                else{
                    self.diplayName = object.object?.postedUser?.displayName ?? "default value"
                    print(self.diplayName)
    //                self.contentString = object.object?.data?["text"] as! String
    //
                    self.url = object.object?.postedUser?.avatarCustomUrl ?? "default value"
                     
           
                    
                    tableView.reloadData()
                }})
             
     
                return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AmityPostFooterTableViewCell", for: indexPath) as! AmityPostFooterTableViewCell
                     // ... populate cell data here
            cell.display(post: self.post)
                     return cell
        default:
                        fatalError("indexPath is out of bound")
        }
    }
    
    // Height for each cell component
    func getComponentHeight(indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}



extension ViewController: AmityFeedDataSource {
    
    // 2.
    // Provide your rendering component for custom post.
    func getUIComponentForPost(post: AmityPostModel, at index: Int) -> AmityPostComposable? {
        switch post.dataType {
        case "custom.sharepost":
            return MyCustomPostComponent(post: post)
        default:
            return nil
        }
    }
}


