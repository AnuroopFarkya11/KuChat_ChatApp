class UserModel {

  late String userId="";
  late String name="";
  late String email="";



  late String password="";
  late String profilePicturePath="";
  late String downloadUrl="";
  late String userBio="";

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
