class MessageModel {
  String msgId;
  final String image;
  final String vendorImage;
  final String name;
  final String date;
  final String description;

  MessageModel({
    required this.msgId,
    required this.image,
    required this.vendorImage,
    required this.name,
    required this.date,
    required this.description,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      msgId: map['msgId'] ?? "",
      image: map['image'] ?? "",
      name: map['name'] ?? "",
      date: map['date'] ?? "",
      vendorImage: map['vendorImage'] ?? "",
      description: map['description'] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'msgId': msgId,
      'image': image,
      'name': name,
      'date': date,
      'vendorImage': vendorImage,
      'description': description,
    };
  }
}

final List<MessageModel> messages = [
  MessageModel(
    msgId: "",
    image:
        "https://www.momondo.in/himg/b1/a8/e3/revato-1172876-6930557-765128.jpg",
    vendorImage:
        "https://images.ctfassets.net/h6goo9gw1hh6/2sNZtFAWOdP1lmQ33VwRN3/24e953b920a9cd0ff2e1d587742a2472/1-intro-photo-final.jpg?w=1200&h=992&fl=progressive&q=70&fm=jpg",
    name: "Andrea",
    date: "7/25/23",
    description:
        "You: Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ",
  ),
  MessageModel(
    msgId: "",
    image:
        "https://www.telegraph.co.uk/content/dam/Travel/hotels/2023/september/one-and-only-cape-town-product-image.jpg",
    vendorImage:
        "https://www.perfocal.com/blog/content/images/size/w960/2021/01/Perfocal_17-11-2019_TYWFAQ_100_standard-3.jpg",
    name: "Nikolaus",
    date: "7/14/23",
    description: "Vendor: Your reservation confirm",
  ),
  MessageModel(
    msgId: "",
    image: "https://www.theindiahotel.com/extra-images/banner-01.jpg",
    vendorImage:
        "https://shotkit.com/wp-content/uploads/bb-plugin/cache/cool-profile-pic-matheus-ferrero-landscape-6cbeea07ce870fc53bedd94909941a4b-zybravgx2q47.jpeg",
    name: "Manfred & Marcella",
    date: "7/2/23",
    description: "WanderStay: Stay updated with our WanderStay",
  ),
  MessageModel(
    msgId: "",
    image:
        "https://www.momondo.in/himg/b1/a8/e3/revato-1172876-6930557-765128.jpg",
    vendorImage:
        "https://images.ctfassets.net/h6goo9gw1hh6/2sNZtFAWOdP1lmQ33VwRN3/24e953b920a9cd0ff2e1d587742a2472/1-intro-photo-final.jpg?w=1200&h=992&fl=progressive&q=70&fm=jpg",
    name: "Andrea",
    date: "7/25/23",
    description:
        "You: Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ",
  ),
  MessageModel(
    msgId: "",
    image:
        "https://www.telegraph.co.uk/content/dam/Travel/hotels/2023/september/one-and-only-cape-town-product-image.jpg",
    vendorImage:
        "https://www.perfocal.com/blog/content/images/size/w960/2021/01/Perfocal_17-11-2019_TYWFAQ_100_standard-3.jpg",
    name: "Nikolaus",
    date: "7/14/23",
    description: "Vendor: Your reservation confirm",
  ),
  MessageModel(
    msgId: "",
    image: "https://www.theindiahotel.com/extra-images/banner-01.jpg",
    vendorImage:
        "https://shotkit.com/wp-content/uploads/bb-plugin/cache/cool-profile-pic-matheus-ferrero-landscape-6cbeea07ce870fc53bedd94909941a4b-zybravgx2q47.jpeg",
    name: "Manfred & Marcella",
    date: "7/2/23",
    description: "WanderStay: Stay updated with our WanderStay",
  ),
  MessageModel(
    msgId: "",
    image:
        "https://www.momondo.in/himg/b1/a8/e3/revato-1172876-6930557-765128.jpg",
    vendorImage:
        "https://images.ctfassets.net/h6goo9gw1hh6/2sNZtFAWOdP1lmQ33VwRN3/24e953b920a9cd0ff2e1d587742a2472/1-intro-photo-final.jpg?w=1200&h=992&fl=progressive&q=70&fm=jpg",
    name: "Andrea",
    date: "7/25/23",
    description:
        "You: Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ",
  ),
  MessageModel(
    msgId: "",
    image:
        "https://www.telegraph.co.uk/content/dam/Travel/hotels/2023/september/one-and-only-cape-town-product-image.jpg",
    vendorImage:
        "https://www.perfocal.com/blog/content/images/size/w960/2021/01/Perfocal_17-11-2019_TYWFAQ_100_standard-3.jpg",
    name: "Nikolaus",
    date: "7/14/23",
    description: "Vendor: Your reservation confirm",
  ),
  MessageModel(
    msgId: "",
    image: "https://www.theindiahotel.com/extra-images/banner-01.jpg",
    vendorImage:
        "https://shotkit.com/wp-content/uploads/bb-plugin/cache/cool-profile-pic-matheus-ferrero-landscape-6cbeea07ce870fc53bedd94909941a4b-zybravgx2q47.jpeg",
    name: "Manfred & Marcella",
    date: "7/2/23",
    description: "WanderStay: Stay updated with our WanderStay",
  ),
  MessageModel(
    msgId: "",
    image:
        "https://www.momondo.in/himg/b1/a8/e3/revato-1172876-6930557-765128.jpg",
    vendorImage:
        "https://images.ctfassets.net/h6goo9gw1hh6/2sNZtFAWOdP1lmQ33VwRN3/24e953b920a9cd0ff2e1d587742a2472/1-intro-photo-final.jpg?w=1200&h=992&fl=progressive&q=70&fm=jpg",
    name: "Andrea",
    date: "7/25/23",
    description:
        "You: Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ",
  ),
  MessageModel(
    msgId: "",
    image:
        "https://www.telegraph.co.uk/content/dam/Travel/hotels/2023/september/one-and-only-cape-town-product-image.jpg",
    vendorImage:
        "https://www.perfocal.com/blog/content/images/size/w960/2021/01/Perfocal_17-11-2019_TYWFAQ_100_standard-3.jpg",
    name: "Nikolaus",
    date: "7/14/23",
    description: "Vendor: Your reservation confirm",
  ),
  MessageModel(
    msgId: "",
    image: "https://www.theindiahotel.com/extra-images/banner-01.jpg",
    vendorImage:
        "https://shotkit.com/wp-content/uploads/bb-plugin/cache/cool-profile-pic-matheus-ferrero-landscape-6cbeea07ce870fc53bedd94909941a4b-zybravgx2q47.jpeg",
    name: "Manfred & Marcella",
    date: "7/2/23",
    description: "WanderStay: Stay updated with our WanderStay",
  ),
];
