class Vendor {
  String uid;
  int coolJarStock;
  int bottleJarStock;
  String defaultGroup;
  String driverName;
  String driverMobileNumber;
  String fullBusinessName;
  String brandName;
  String stateName;
  String cityName;
  String mobileNumber;

  Vendor(this.uid,
      this.bottleJarStock,
      this.brandName,
      this.cityName,
      this.coolJarStock,
      this.defaultGroup,
      this.driverMobileNumber,
      this.driverName,
      this.fullBusinessName,
      this.mobileNumber,
      this.stateName);

  Map<String,dynamic> toJson()=>{
    'uid':uid,
    'bottleJarStock':bottleJarStock,
    'brandName':brandName,
    'cityName':cityName,
    'coolJarStock':coolJarStock,
    'defaultGroup':defaultGroup,
    'driverMobileNumber':driverMobileNumber,
    'driverName':driverName,
    'fullBusinessName':fullBusinessName,
    'mobileNumber':mobileNumber,
    'stateName':stateName,
  };
}