class UserModel {

  late String userId="";
  late String name="";
  late String email="";
  late String password="";
  late String downloadUrl="https://firebasestorage.googleapis.com/v0/b/kuchat-2ef55.appspot.com/o/ProfileImages%2FdefaultImage.png?alt=media&token=f8b13f8e-a8e0-45f7-be92-19d6abc81abc";
  late String profilePicturePath="";
  late String userBio="Hello! I am a KuChat user!";

  toJSON(){
    return{
      "Name":name,
      "UserID":userId,
      "EmailAddress":email,
      "Password":password,
      "ProfilePictureURL":downloadUrl,
      "userBio":userBio
    };
  }
}
