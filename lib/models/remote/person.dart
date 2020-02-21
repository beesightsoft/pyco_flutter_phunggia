class Person {
  User user;
  String seed;
  String version;

  Person({this.user, this.seed, this.version});

  /*Person.fromJson(Map<String, dynamic> json) {
    user = json['results'][0]['user'] != null ? new User.fromJson(json['results'][0]['user']) : null;
    seed = json['results'][0]['seed'];
    version = json['results'][0]['version'];
  }*/

  Person.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    seed = json['seed'];
    version = json['version'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    data['seed'] = this.seed;
    data['version'] = this.version;
    return data;
  }
}

class User {
  String gender;
  Name name;
  Location location;
  String email;
  String username;
  String password;
  String salt;
  String md5;
  String sha1;
  String sha256;
  String registered;
  String dob;
  String phone;
  String cell;
  String sSN;
  String picture;

  User(
      {this.gender,
        this.name,
        this.location,
        this.email,
        this.username,
        this.password,
        this.salt,
        this.md5,
        this.sha1,
        this.sha256,
        this.registered,
        this.dob,
        this.phone,
        this.cell,
        this.sSN,
        this.picture});

  User.fromJson(Map<String, dynamic> json) {
    gender = json['gender'];
    name = json['name'] != null ? new Name.fromJson(json['name']) : null;
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
    email = json['email'];
    username = json['username'];
    password = json['password'];
    salt = json['salt'];
    md5 = json['md5'];
    sha1 = json['sha1'];
    sha256 = json['sha256'];
    registered = json['registered'];
    dob = json['dob'];
    phone = json['phone'];
    cell = json['cell'];
    sSN = json['SSN'];
    picture = json['picture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gender'] = this.gender;
    if (this.name != null) {
      data['name'] = this.name.toJson();
    }
    if (this.location != null) {
      data['location'] = this.location.toJson();
    }
    data['email'] = this.email;
    data['username'] = this.username;
    data['password'] = this.password;
    data['salt'] = this.salt;
    data['md5'] = this.md5;
    data['sha1'] = this.sha1;
    data['sha256'] = this.sha256;
    data['registered'] = this.registered;
    data['dob'] = this.dob;
    data['phone'] = this.phone;
    data['cell'] = this.cell;
    data['SSN'] = this.sSN;
    data['picture'] = this.picture;
    return data;
  }
}

class Name {
  String title;
  String first;
  String last;

  Name({this.title, this.first, this.last});

  Name.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    first = json['first'];
    last = json['last'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['first'] = this.first;
    data['last'] = this.last;
    return data;
  }
}

class Location {
  String street;
  String city;
  String state;
  String zip;

  Location({this.street, this.city, this.state, this.zip});

  Location.fromJson(Map<String, dynamic> json) {
    street = json['street'];
    city = json['city'];
    state = json['state'];
    zip = json['zip'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['street'] = this.street;
    data['city'] = this.city;
    data['state'] = this.state;
    data['zip'] = this.zip;
    return data;
  }
}