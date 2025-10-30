class CarModel {
  final String id;
  final DateTime? timestamp;
  final String emailAddress;
  final String appointmentId;
  final String city;
  final String registrationType;
  final String rcBookAvailability;
  final String rcCondition;
  final String registrationNumber;
  final DateTime? registrationDate;
  final DateTime? fitnessTill;
  final String toBeScrapped;
  final String registrationState;
  final String registeredRto;
  final int ownerSerialNumber;
  final String make;
  final String model;
  final String variant;
  final String engineNumber;
  final String chassisNumber;
  final String registeredOwner;
  final String registeredAddressAsPerRc;
  final DateTime? yearMonthOfManufacture;
  final String fuelType;
  final int cubicCapacity;
  final String hypothecationDetails;
  final String mismatchInRc;
  final String roadTaxValidity;
  final DateTime? taxValidTill;
  final String insurance;
  final String insurancePolicyNumber;
  final DateTime? insuranceValidity;
  final String noClaimBonus;
  final String mismatchInInsurance;
  final String duplicateKey;
  final String rtoNoc;
  final String rtoForm28;
  final String partyPeshi;
  final String additionalDetails;
  final List<String> rcTaxToken;
  final List<String> insuranceCopy;
  final List<String> bothKeys;
  final List<String> form26GdCopyIfRcIsLost;
  final String bonnet;
  final String frontWindshield;
  final String roof;
  final String frontBumper;
  final String lhsHeadlamp;
  final String lhsFoglamp;
  final String rhsHeadlamp;
  final String rhsFoglamp;
  final String lhsFender;
  final String lhsOrvm;
  final String lhsAPillar;
  final String lhsBPillar;
  final String lhsCPillar;
  final String lhsFrontAlloy;
  final String lhsFrontTyre;
  final String lhsRearAlloy;
  final String lhsRearTyre;
  final String lhsFrontDoor;
  final String lhsRearDoor;
  final String lhsRunningBorder;
  final String lhsQuarterPanel;
  final String rearBumper;
  final String lhsTailLamp;
  final String rhsTailLamp;
  final String rearWindshield;
  final String bootDoor;
  final String spareTyre;
  final String bootFloor;
  final String rhsRearAlloy;
  final String rhsRearTyre;
  final String rhsFrontAlloy;
  final String rhsFrontTyre;
  final String rhsQuarterPanel;
  final String rhsAPillar;
  final String rhsBPillar;
  final String rhsCPillar;
  final String rhsRunningBorder;
  final String rhsRearDoor;
  final String rhsFrontDoor;
  final String rhsOrvm;
  final String rhsFender;
  final String comments;
  final List<String> frontMain;
  final List<String> bonnetImages;
  final List<String> frontWindshieldImages;
  final List<String> roofImages;
  final List<String> frontBumperImages;
  final List<String> lhsHeadlampImages;
  final List<String> lhsFoglampImages;
  final List<String> rhsHeadlampImages;
  final List<String> rhsFoglampImages;
  final List<String> lhsFront45Degree;
  final List<String> lhsFenderImages;
  final List<String> lhsFrontAlloyImages;
  final List<String> lhsFrontTyreImages;
  final List<String> lhsRunningBorderImages;
  final List<String> lhsOrvmImages;
  final List<String> lhsAPillarImages;
  final List<String> lhsFrontDoorImages;
  final List<String> lhsBPillarImages;
  final List<String> lhsRearDoorImages;
  final List<String> lhsCPillarImages;
  final List<String> lhsRearTyreImages;
  final List<String> lhsRearAlloyImages;
  final List<String> lhsQuarterPanelImages;
  final List<String> rearMain;
  final String rearWithBootDoorOpen;
  final List<String> rearBumperImages;
  final List<String> lhsTailLampImages;
  final List<String> rhsTailLampImages;
  final List<String> rearWindshieldImages;
  final List<String> spareTyreImages;
  final List<String> bootFloorImages;
  final List<String> rhsRear45Degree;
  final List<String> rhsQuarterPanelImages;
  final List<String> rhsRearAlloyImages;
  final List<String> rhsRearTyreImages;
  final List<String> rhsCPillarImages;
  final List<String> rhsRearDoorImages;
  final List<String> rhsBPillarImages;
  final List<String> rhsFrontDoorImages;
  final List<String> rhsAPillarImages;
  final List<String> rhsRunningBorderImages;
  final List<String> rhsFrontAlloyImages;
  final List<String> rhsFrontTyreImages;
  final List<String> rhsOrvmImages;
  final List<String> rhsFenderImages;
  final String upperCrossMember;
  final String radiatorSupport;
  final String headlightSupport;
  final String lowerCrossMember;
  final String lhsApron;
  final String rhsApron;
  final String firewall;
  final String cowlTop;
  final String engine;
  final String battery;
  final String coolant;
  final String engineOilLevelDipstick;
  final String engineOil;
  final String engineMount;
  final String enginePermisableBlowBy;
  final String exhaustSmoke;
  final String clutch;
  final String gearShift;
  final String commentsOnEngine;
  final String commentsOnEngineOil;
  final String commentsOnTowing;
  final String commentsOnTransmission;
  final String commentsOnRadiator;
  final String commentsOnOthers;
  final List<String> engineBay;
  final List<String> apronLhsRhs;
  final List<String> batteryImages;
  final List<String> additionalImages;
  final List<String> engineSound;
  final List<String> exhaustSmokeImages;
  final String steering;
  final String brakes;
  final String suspension;
  final int odometerReadingInKms;
  final String fuelLevel;
  final String abs;
  final String electricals;
  final String rearWiperWasher;
  final String rearDefogger;
  final String musicSystem;
  final String stereo;
  final String inbuiltSpeaker;
  final String externalSpeaker;
  final String steeringMountedAudioControl;
  final String noOfPowerWindows;
  final String powerWindowConditionRhsFront;
  final String powerWindowConditionLhsFront;
  final String powerWindowConditionRhsRear;
  final String powerWindowConditionLhsRear;
  final String commentOnInterior;
  final int noOfAirBags;
  final String airbagFeaturesDriverSide;
  final String airbagFeaturesCoDriverSide;
  final String airbagFeaturesLhsAPillarCurtain;
  final String airbagFeaturesLhsBPillarCurtain;
  final String airbagFeaturesLhsCPillarCurtain;
  final String airbagFeaturesRhsAPillarCurtain;
  final String airbagFeaturesRhsBPillarCurtain;
  final String airbagFeaturesRhsCPillarCurtain;
  final String sunroof;
  final String leatherSeats;
  final String fabricSeats;
  final String commentsOnElectricals;
  final List<String> meterConsoleWithEngineOn;
  final List<String> airbags;
  final List<String> sunroofImages;
  final List<String> frontSeatsFromDriverSideDoorOpen;
  final List<String> rearSeatsFromRightSideDoorOpen;
  final List<String> dashboardFromRearSeat;
  final String reverseCamera;
  final List<String> additionalImages2;
  final String airConditioningManual;
  final String airConditioningClimateControl;
  final String commentsOnAc;
  final String approvedBy;
  final DateTime? approvalDate;
  final DateTime? approvalTime;
  final String approvalStatus;
  final String contactNumber;
  final DateTime? newArrivalMessage;
  final String budgetCar;
  final String status;
  final int priceDiscovery;
  final String priceDiscoveryBy;
  final String latlong;
  final String retailAssociate;
  final int kmRangeLevel;
  final String highestBidder;
  final int v;
  CarModel({
    required this.id,
    required this.timestamp,
    required this.emailAddress,
    required this.appointmentId,
    required this.city,
    required this.registrationType,
    required this.rcBookAvailability,
    required this.rcCondition,
    required this.registrationNumber,
    required this.registrationDate,
    required this.fitnessTill,
    required this.toBeScrapped,
    required this.registrationState,
    required this.registeredRto,
    required this.ownerSerialNumber,
    required this.make,
    required this.model,
    required this.variant,
    required this.engineNumber,
    required this.chassisNumber,
    required this.registeredOwner,
    required this.registeredAddressAsPerRc,
    required this.yearMonthOfManufacture,
    required this.fuelType,
    required this.cubicCapacity,
    required this.hypothecationDetails,
    required this.mismatchInRc,
    required this.roadTaxValidity,
    required this.taxValidTill,
    required this.insurance,
    required this.insurancePolicyNumber,
    required this.insuranceValidity,
    required this.noClaimBonus,
    required this.mismatchInInsurance,
    required this.duplicateKey,
    required this.rtoNoc,
    required this.rtoForm28,
    required this.partyPeshi,
    required this.additionalDetails,
    required this.rcTaxToken,
    required this.insuranceCopy,
    required this.bothKeys,
    required this.form26GdCopyIfRcIsLost,
    required this.bonnet,
    required this.frontWindshield,
    required this.roof,
    required this.frontBumper,
    required this.lhsHeadlamp,
    required this.lhsFoglamp,
    required this.rhsHeadlamp,
    required this.rhsFoglamp,
    required this.lhsFender,
    required this.lhsOrvm,
    required this.lhsAPillar,
    required this.lhsBPillar,
    required this.lhsCPillar,
    required this.lhsFrontAlloy,
    required this.lhsFrontTyre,
    required this.lhsRearAlloy,
    required this.lhsRearTyre,
    required this.lhsFrontDoor,
    required this.lhsRearDoor,
    required this.lhsRunningBorder,
    required this.lhsQuarterPanel,
    required this.rearBumper,
    required this.lhsTailLamp,
    required this.rhsTailLamp,
    required this.rearWindshield,
    required this.bootDoor,
    required this.spareTyre,
    required this.bootFloor,
    required this.rhsRearAlloy,
    required this.rhsRearTyre,
    required this.rhsFrontAlloy,
    required this.rhsFrontTyre,
    required this.rhsQuarterPanel,
    required this.rhsAPillar,
    required this.rhsBPillar,
    required this.rhsCPillar,
    required this.rhsRunningBorder,
    required this.rhsRearDoor,
    required this.rhsFrontDoor,
    required this.rhsOrvm,
    required this.rhsFender,
    required this.comments,
    required this.frontMain,
    required this.bonnetImages,
    required this.frontWindshieldImages,
    required this.roofImages,
    required this.frontBumperImages,
    required this.lhsHeadlampImages,
    required this.lhsFoglampImages,
    required this.rhsHeadlampImages,
    required this.rhsFoglampImages,
    required this.lhsFront45Degree,
    required this.lhsFenderImages,
    required this.lhsFrontAlloyImages,
    required this.lhsFrontTyreImages,
    required this.lhsRunningBorderImages,
    required this.lhsOrvmImages,
    required this.lhsAPillarImages,
    required this.lhsFrontDoorImages,
    required this.lhsBPillarImages,
    required this.lhsRearDoorImages,
    required this.lhsCPillarImages,
    required this.lhsRearTyreImages,
    required this.lhsRearAlloyImages,
    required this.lhsQuarterPanelImages,
    required this.rearMain,
    required this.rearWithBootDoorOpen,
    required this.rearBumperImages,
    required this.lhsTailLampImages,
    required this.rhsTailLampImages,
    required this.rearWindshieldImages,
    required this.spareTyreImages,
    required this.bootFloorImages,
    required this.rhsRear45Degree,
    required this.rhsQuarterPanelImages,
    required this.rhsRearAlloyImages,
    required this.rhsRearTyreImages,
    required this.rhsCPillarImages,
    required this.rhsRearDoorImages,
    required this.rhsBPillarImages,
    required this.rhsFrontDoorImages,
    required this.rhsAPillarImages,
    required this.rhsRunningBorderImages,
    required this.rhsFrontAlloyImages,
    required this.rhsFrontTyreImages,
    required this.rhsOrvmImages,
    required this.rhsFenderImages,
    required this.upperCrossMember,
    required this.radiatorSupport,
    required this.headlightSupport,
    required this.lowerCrossMember,
    required this.lhsApron,
    required this.rhsApron,
    required this.firewall,
    required this.cowlTop,
    required this.engine,
    required this.battery,
    required this.coolant,
    required this.engineOilLevelDipstick,
    required this.engineOil,
    required this.engineMount,
    required this.enginePermisableBlowBy,
    required this.exhaustSmoke,
    required this.clutch,
    required this.gearShift,
    required this.commentsOnEngine,
    required this.commentsOnEngineOil,
    required this.commentsOnTowing,
    required this.commentsOnTransmission,
    required this.commentsOnRadiator,
    required this.commentsOnOthers,
    required this.engineBay,
    required this.apronLhsRhs,
    required this.batteryImages,
    required this.additionalImages,
    required this.engineSound,
    required this.exhaustSmokeImages,
    required this.steering,
    required this.brakes,
    required this.suspension,
    required this.odometerReadingInKms,
    required this.fuelLevel,
    required this.abs,
    required this.electricals,
    required this.rearWiperWasher,
    required this.rearDefogger,
    required this.musicSystem,
    required this.stereo,
    required this.inbuiltSpeaker,
    required this.externalSpeaker,
    required this.steeringMountedAudioControl,
    required this.noOfPowerWindows,
    required this.powerWindowConditionRhsFront,
    required this.powerWindowConditionLhsFront,
    required this.powerWindowConditionRhsRear,
    required this.powerWindowConditionLhsRear,
    required this.commentOnInterior,
    required this.noOfAirBags,
    required this.airbagFeaturesDriverSide,
    required this.airbagFeaturesCoDriverSide,
    required this.airbagFeaturesLhsAPillarCurtain,
    required this.airbagFeaturesLhsBPillarCurtain,
    required this.airbagFeaturesLhsCPillarCurtain,
    required this.airbagFeaturesRhsAPillarCurtain,
    required this.airbagFeaturesRhsBPillarCurtain,
    required this.airbagFeaturesRhsCPillarCurtain,
    required this.sunroof,
    required this.leatherSeats,
    required this.fabricSeats,
    required this.commentsOnElectricals,
    required this.meterConsoleWithEngineOn,
    required this.airbags,
    required this.sunroofImages,
    required this.frontSeatsFromDriverSideDoorOpen,
    required this.rearSeatsFromRightSideDoorOpen,
    required this.dashboardFromRearSeat,
    required this.reverseCamera,
    required this.additionalImages2,
    required this.airConditioningManual,
    required this.airConditioningClimateControl,
    required this.commentsOnAc,
    required this.approvedBy,
    required this.approvalDate,
    required this.approvalTime,
    required this.approvalStatus,
    required this.contactNumber,
    required this.newArrivalMessage,
    required this.budgetCar,
    required this.status,
    required this.priceDiscovery,
    required this.priceDiscoveryBy,
    required this.latlong,
    required this.retailAssociate,
    required this.kmRangeLevel,
    required this.highestBidder,
    required this.v,
  });

  factory CarModel.fromJson({
    required Map<String, dynamic> json,
    required String documentId,
  }) {
    return CarModel(
      id: documentId,
      timestamp: parseMongoDbDate(json["timestamp"]),
      emailAddress: json["emailAddress"] ?? 'N/A',
      appointmentId: json["appointmentId"] ?? 'N/A',
      city: json["city"] ?? 'N/A',
      registrationType: json["registrationType"] ?? 'N/A',
      rcBookAvailability: json["rcBookAvailability"] ?? 'N/A',
      rcCondition: json["rcCondition"] ?? 'N/A',
      registrationNumber: json["registrationNumber"] ?? 'N/A',
      registrationDate: parseMongoDbDate(json["registrationDate"]),
      fitnessTill: parseMongoDbDate(json["fitnessTill"]),
      toBeScrapped: json["toBeScrapped"] ?? 'N/A',
      registrationState: json["registrationState"] ?? 'N/A',
      registeredRto: json["registeredRto"] ?? 'N/A',
      ownerSerialNumber: json["ownerSerialNumber"] ?? 0,
      make: json["make"] ?? 'N/A',
      model: json["model"] ?? 'N/A',
      variant: json["variant"] ?? 'N/A',
      engineNumber: json["engineNumber"] ?? 'N/A',
      chassisNumber: json["chassisNumber"] ?? 'N/A',
      registeredOwner: json["registeredOwner"] ?? 'N/A',
      registeredAddressAsPerRc: json["registeredAddressAsPerRc"] ?? 'N/A',
      yearMonthOfManufacture: parseMongoDbDate(json["yearMonthOfManufacture"]),
      fuelType: json["fuelType"] ?? 'N/A',
      cubicCapacity: json["cubicCapacity"] ?? 0,
      hypothecationDetails: json["hypothecationDetails"] ?? 'N/A',
      mismatchInRc: json["mismatchInRc"] ?? 'N/A',
      roadTaxValidity: json["roadTaxValidity"] ?? 'N/A',
      taxValidTill: parseMongoDbDate(json["taxValidTill"]),
      insurance: json["insurance"] ?? 'N/A',
      insurancePolicyNumber: json["insurancePolicyNumber"] ?? 'N/A',
      insuranceValidity: parseMongoDbDate(json["insuranceValidity"]),
      noClaimBonus: json["noClaimBonus"] ?? 'N/A',
      mismatchInInsurance: json["mismatchInInsurance"] ?? 'N/A',
      duplicateKey: json["duplicateKey"] ?? 'N/A',
      rtoNoc: json["rtoNoc"] ?? 'N/A',
      rtoForm28: json["rtoForm28"] ?? 'N/A',
      partyPeshi: json["partyPeshi"] ?? 'N/A',
      additionalDetails: json["additionalDetails"] ?? 'N/A',
      rcTaxToken: parseStringList(json["rcTaxToken"]),
      insuranceCopy: parseStringList(json["insuranceCopy"]),
      bothKeys: parseStringList(json["bothKeys"]),
      form26GdCopyIfRcIsLost: parseStringList(json["form26GdCopyIfRcIsLost"]),
      bonnet: json["bonnet"] ?? 'N/A',
      frontWindshield: json["frontWindshield"] ?? 'N/A',
      roof: json["roof"] ?? 'N/A',
      frontBumper: json["frontBumper"] ?? 'N/A',
      lhsHeadlamp: json["lhsHeadlamp"] ?? 'N/A',
      lhsFoglamp: json["lhsFoglamp"] ?? 'N/A',
      rhsHeadlamp: json["rhsHeadlamp"] ?? 'N/A',
      rhsFoglamp: json["rhsFoglamp"] ?? 'N/A',
      lhsFender: json["lhsFender"] ?? 'N/A',
      lhsOrvm: json["lhsOrvm"] ?? 'N/A',
      lhsAPillar: json["lhsAPillar"] ?? 'N/A',
      lhsBPillar: json["lhsBPillar"] ?? 'N/A',
      lhsCPillar: json["lhsCPillar"] ?? 'N/A',
      lhsFrontAlloy: json["lhsFrontAlloy"] ?? 'N/A',
      lhsFrontTyre: json["lhsFrontTyre"] ?? 'N/A',
      lhsRearAlloy: json["lhsRearAlloy"] ?? 'N/A',
      lhsRearTyre: json["lhsRearTyre"] ?? 'N/A',
      lhsFrontDoor: json["lhsFrontDoor"] ?? 'N/A',
      lhsRearDoor: json["lhsRearDoor"] ?? 'N/A',
      lhsRunningBorder: json["lhsRunningBorder"] ?? 'N/A',
      lhsQuarterPanel: json["lhsQuarterPanel"] ?? 'N/A',
      rearBumper: json["rearBumper"] ?? 'N/A',
      lhsTailLamp: json["lhsTailLamp"] ?? 'N/A',
      rhsTailLamp: json["rhsTailLamp"] ?? 'N/A',
      rearWindshield: json["rearWindshield"] ?? 'N/A',
      bootDoor: json["bootDoor"] ?? 'N/A',
      spareTyre: json["spareTyre"] ?? 'N/A',
      bootFloor: json["bootFloor"] ?? 'N/A',
      rhsRearAlloy: json["rhsRearAlloy"] ?? 'N/A',
      rhsRearTyre: json["rhsRearTyre"] ?? 'N/A',
      rhsFrontAlloy: json["rhsFrontAlloy"] ?? 'N/A',
      rhsFrontTyre: json["rhsFrontTyre"] ?? 'N/A',
      rhsQuarterPanel: json["rhsQuarterPanel"] ?? 'N/A',
      rhsAPillar: json["rhsAPillar"] ?? 'N/A',
      rhsBPillar: json["rhsBPillar"] ?? 'N/A',
      rhsCPillar: json["rhsCPillar"] ?? 'N/A',
      rhsRunningBorder: json["rhsRunningBorder"] ?? 'N/A',
      rhsRearDoor: json["rhsRearDoor"] ?? 'N/A',
      rhsFrontDoor: json["rhsFrontDoor"] ?? 'N/A',
      rhsOrvm: json["rhsOrvm"] ?? 'N/A',
      rhsFender: json["rhsFender"] ?? 'N/A',
      comments: json["comments"] ?? 'N/A',
      frontMain: parseStringList(json["frontMain"]),
      bonnetImages: parseStringList(json["bonnetImages"]),
      frontWindshieldImages: parseStringList(json["frontWindshieldImages"]),
      roofImages: parseStringList(json["roofImages"]),
      frontBumperImages: parseStringList(json["frontBumperImages"]),
      lhsHeadlampImages: parseStringList(json["lhsHeadlampImages"]),
      lhsFoglampImages: parseStringList(json["lhsFoglampImages"]),
      rhsHeadlampImages: parseStringList(json["rhsHeadlampImages"]),
      rhsFoglampImages: parseStringList(json["rhsFoglampImages"]),
      lhsFront45Degree: parseStringList(json["lhsFront45Degree"]),
      lhsFenderImages: parseStringList(json["lhsFenderImages"]),
      lhsFrontAlloyImages: parseStringList(json["lhsFrontAlloyImages"]),
      lhsFrontTyreImages: parseStringList(json["lhsFrontTyreImages"]),
      lhsRunningBorderImages: parseStringList(json["lhsRunningBorderImages"]),
      lhsOrvmImages: parseStringList(json["lhsOrvmImages"]),
      lhsAPillarImages: parseStringList(json["lhsAPillarImages"]),
      lhsFrontDoorImages: parseStringList(json["lhsFrontDoorImages"]),
      lhsBPillarImages: parseStringList(json["lhsBPillarImages"]),
      lhsRearDoorImages: parseStringList(json["lhsRearDoorImages"]),
      lhsCPillarImages: parseStringList(json["lhsCPillarImages"]),
      lhsRearTyreImages: parseStringList(json["lhsRearTyreImages"]),
      lhsRearAlloyImages: parseStringList(json["lhsRearAlloyImages"]),
      lhsQuarterPanelImages: parseStringList(json["lhsQuarterPanelImages"]),
      rearMain: parseStringList(json["rearMain"]),
      rearWithBootDoorOpen: json["rearWithBootDoorOpen"] ?? 'N/A',
      rearBumperImages: parseStringList(json["rearBumperImages"]),
      lhsTailLampImages: parseStringList(json["lhsTailLampImages"]),
      rhsTailLampImages: parseStringList(json["rhsTailLampImages"]),
      rearWindshieldImages: parseStringList(json["rearWindshieldImages"]),
      spareTyreImages: parseStringList(json["spareTyreImages"]),
      bootFloorImages: parseStringList(json["bootFloorImages"]),
      rhsRear45Degree: parseStringList(json["rhsRear45Degree"]),
      rhsQuarterPanelImages: parseStringList(json["rhsQuarterPanelImages"]),
      rhsRearAlloyImages: parseStringList(json["rhsRearAlloyImages"]),
      rhsRearTyreImages: parseStringList(json["rhsRearTyreImages"]),
      rhsCPillarImages: parseStringList(json["rhsCPillarImages"]),
      rhsRearDoorImages: parseStringList(json["rhsRearDoorImages"]),
      rhsBPillarImages: parseStringList(json["rhsBPillarImages"]),
      rhsFrontDoorImages: parseStringList(json["rhsFrontDoorImages"]),
      rhsAPillarImages: parseStringList(json["rhsAPillarImages"]),
      rhsRunningBorderImages: parseStringList(json["rhsRunningBorderImages"]),
      rhsFrontAlloyImages: parseStringList(json["rhsFrontAlloyImages"]),
      rhsFrontTyreImages: parseStringList(json["rhsFrontTyreImages"]),
      rhsOrvmImages: parseStringList(json["rhsOrvmImages"]),
      rhsFenderImages: parseStringList(json["rhsFenderImages"]),
      upperCrossMember: json["upperCrossMember"] ?? 'N/A',
      radiatorSupport: json["radiatorSupport"] ?? 'N/A',
      headlightSupport: json["headlightSupport"] ?? 'N/A',
      lowerCrossMember: json["lowerCrossMember"] ?? 'N/A',
      lhsApron: json["lhsApron"] ?? 'N/A',
      rhsApron: json["rhsApron"] ?? 'N/A',
      firewall: json["firewall"] ?? 'N/A',
      cowlTop: json["cowlTop"] ?? 'N/A',
      engine: json["engine"] ?? 'N/A',
      battery: json["battery"] ?? 'N/A',
      coolant: json["coolant"] ?? 'N/A',
      engineOilLevelDipstick: json["engineOilLevelDipstick"] ?? 'N/A',
      engineOil: json["engineOil"] ?? 'N/A',
      engineMount: json["engineMount"] ?? 'N/A',
      enginePermisableBlowBy: json["enginePermisableBlowBy"] ?? 'N/A',
      exhaustSmoke: json["exhaustSmoke"] ?? 'N/A',
      clutch: json["clutch"] ?? 'N/A',
      gearShift: json["gearShift"] ?? 'N/A',
      commentsOnEngine: json["commentsOnEngine"] ?? 'N/A',
      commentsOnEngineOil: json["commentsOnEngineOil"] ?? 'N/A',
      commentsOnTowing: json["commentsOnTowing"] ?? 'N/A',
      commentsOnTransmission: json["commentsOnTransmission"] ?? 'N/A',
      commentsOnRadiator: json["commentsOnRadiator"] ?? 'N/A',
      commentsOnOthers: json["commentsOnOthers"] ?? 'N/A',
      engineBay: parseStringList(json["engineBay"]),
      apronLhsRhs: parseStringList(json["apronLhsRhs"]),
      batteryImages: parseStringList(json["batteryImages"]),
      additionalImages: parseStringList(json["additionalImages"]),
      engineSound: parseStringList(json["engineSound"]),
      exhaustSmokeImages: parseStringList(json["exhaustSmokeImages"]),
      steering: json["steering"] ?? 'N/A',
      brakes: json["brakes"] ?? 'N/A',
      suspension: json["suspension"] ?? 'N/A',
      odometerReadingInKms: json["odometerReadingInKms"] ?? 0,
      fuelLevel: json["fuelLevel"] ?? 'N/A',
      abs: json["abs"] ?? 'N/A',
      electricals: json["electricals"] ?? 'N/A',
      rearWiperWasher: json["rearWiperWasher"] ?? 'N/A',
      rearDefogger: json["rearDefogger"] ?? 'N/A',
      musicSystem: json["musicSystem"] ?? 'N/A',
      stereo: json["stereo"] ?? 'N/A',
      inbuiltSpeaker: json["inbuiltSpeaker"] ?? 'N/A',
      externalSpeaker: json["externalSpeaker"] ?? 'N/A',
      steeringMountedAudioControl: json["steeringMountedAudioControl"] ?? 'N/A',
      noOfPowerWindows: json["noOfPowerWindows"] ?? 'N/A',
      powerWindowConditionRhsFront:
          json["powerWindowConditionRhsFront"] ?? 'N/A',
      powerWindowConditionLhsFront:
          json["powerWindowConditionLhsFront"] ?? 'N/A',
      powerWindowConditionRhsRear: json["powerWindowConditionRhsRear"] ?? 'N/A',
      powerWindowConditionLhsRear: json["powerWindowConditionLhsRear"] ?? 'N/A',
      commentOnInterior: json["commentOnInterior"] ?? 'N/A',
      noOfAirBags: json["noOfAirBags"] ?? 0,
      airbagFeaturesDriverSide: json["airbagFeaturesDriverSide"] ?? 'N/A',
      airbagFeaturesCoDriverSide: json["airbagFeaturesCoDriverSide"] ?? 'N/A',
      airbagFeaturesLhsAPillarCurtain:
          json["airbagFeaturesLhsAPillarCurtain"] ?? 'N/A',
      airbagFeaturesLhsBPillarCurtain:
          json["airbagFeaturesLhsBPillarCurtain"] ?? 'N/A',
      airbagFeaturesLhsCPillarCurtain:
          json["airbagFeaturesLhsCPillarCurtain"] ?? 'N/A',
      airbagFeaturesRhsAPillarCurtain:
          json["airbagFeaturesRhsAPillarCurtain"] ?? 'N/A',
      airbagFeaturesRhsBPillarCurtain:
          json["airbagFeaturesRhsBPillarCurtain"] ?? 'N/A',
      airbagFeaturesRhsCPillarCurtain:
          json["airbagFeaturesRhsCPillarCurtain"] ?? 'N/A',
      sunroof: json["sunroof"] ?? 'N/A',
      leatherSeats: json["leatherSeats"] ?? 'N/A',
      fabricSeats: json["fabricSeats"] ?? 'N/A',
      commentsOnElectricals: json["commentsOnElectricals"] ?? 'N/A',
      meterConsoleWithEngineOn: parseStringList(
        json["meterConsoleWithEngineOn"],
      ),
      airbags: parseStringList(json["airbags"]),
      sunroofImages: parseStringList(json["sunroofImages"]),
      frontSeatsFromDriverSideDoorOpen: parseStringList(
        json["frontSeatsFromDriverSideDoorOpen"],
      ),
      rearSeatsFromRightSideDoorOpen: parseStringList(
        json["rearSeatsFromRightSideDoorOpen"],
      ),
      dashboardFromRearSeat: parseStringList(json["dashboardFromRearSeat"]),
      reverseCamera: json["reverseCamera"] ?? 'N/A',
      additionalImages2: parseStringList(json["additionalImages2"]),
      airConditioningManual: json["airConditioningManual"] ?? 'N/A',
      airConditioningClimateControl:
          json["airConditioningClimateControl"] ?? 'N/A',
      commentsOnAc: json["commentsOnAC"] ?? 'N/A',
      approvedBy: json["approvedBy"] ?? 'N/A',
      approvalDate: parseMongoDbDate(json["approvalDate"]),
      approvalTime: parseMongoDbDate(json["approvalTime"]),
      approvalStatus: json["approvalStatus"] ?? 'N/A',
      contactNumber: json["contactNumber"] ?? 'N/A',
      newArrivalMessage: parseMongoDbDate(json["newArrivalMessage"]),
      budgetCar: json["budgetCar"] ?? 'N/A',
      status: json["status"] ?? 'N/A',
      priceDiscovery: json["priceDiscovery"] ?? 0,
      priceDiscoveryBy: json["priceDiscoveryBy"] ?? 'N/A',
      latlong: json["latlong"] ?? 'N/A',
      retailAssociate: json["retailAssociate"] ?? 'N/A',
      kmRangeLevel: json["kmRangeLevel"] ?? 0,
      highestBidder: json["highestBidder"] ?? 'N/A',
      v: json["__v"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    // "_id": id?.toJson(),
    "timestamp": timestamp,
    "emailAddress": emailAddress,
    "appointmentId": appointmentId,
    "city": city,
    "registrationType": registrationType,
    "rcBookAvailability": rcBookAvailability,
    "rcCondition": rcCondition,
    "registrationNumber": registrationNumber,
    "registrationDate": registrationDate,
    "fitnessTill": fitnessTill,
    "toBeScrapped": toBeScrapped,
    "registrationState": registrationState,
    "registeredRto": registeredRto,
    "ownerSerialNumber": ownerSerialNumber,
    "make": make,
    "model": model,
    "variant": variant,
    "engineNumber": engineNumber,
    "chassisNumber": chassisNumber,
    "registeredOwner": registeredOwner,
    "registeredAddressAsPerRc": registeredAddressAsPerRc,
    "yearMonthOfManufacture": yearMonthOfManufacture,
    "fuelType": fuelType,
    "cubicCapacity": cubicCapacity,
    "hypothecationDetails": hypothecationDetails,
    "mismatchInRc": mismatchInRc,
    "roadTaxValidity": roadTaxValidity,
    "taxValidTill": taxValidTill,
    "insurance": insurance,
    "insurancePolicyNumber": insurancePolicyNumber,
    "insuranceValidity": insuranceValidity,
    "noClaimBonus": noClaimBonus,
    "mismatchInInsurance": mismatchInInsurance,
    "duplicateKey": duplicateKey,
    "rtoNoc": rtoNoc,
    "rtoForm28": rtoForm28,
    "partyPeshi": partyPeshi,
    "additionalDetails": additionalDetails,
    "rcTaxToken": rcTaxToken.map((x) => x).toList(),
    "insuranceCopy": insuranceCopy.map((x) => x).toList(),
    "bothKeys": bothKeys,
    "form26GdCopyIfRcIsLost": form26GdCopyIfRcIsLost,
    "bonnet": bonnet,
    "frontWindshield": frontWindshield,
    "roof": roof,
    "frontBumper": frontBumper,
    "lhsHeadlamp": lhsHeadlamp,
    "lhsFoglamp": lhsFoglamp,
    "rhsHeadlamp": rhsHeadlamp,
    "rhsFoglamp": rhsFoglamp,
    "lhsFender": lhsFender,
    "lhsOrvm": lhsOrvm,
    "lhsAPillar": lhsAPillar,
    "lhsBPillar": lhsBPillar,
    "lhsCPillar": lhsCPillar,
    "lhsFrontAlloy": lhsFrontAlloy,
    "lhsFrontTyre": lhsFrontTyre,
    "lhsRearAlloy": lhsRearAlloy,
    "lhsRearTyre": lhsRearTyre,
    "lhsFrontDoor": lhsFrontDoor,
    "lhsRearDoor": lhsRearDoor,
    "lhsRunningBorder": lhsRunningBorder,
    "lhsQuarterPanel": lhsQuarterPanel,
    "rearBumper": rearBumper,
    "lhsTailLamp": lhsTailLamp,
    "rhsTailLamp": rhsTailLamp,
    "rearWindshield": rearWindshield,
    "bootDoor": bootDoor,
    "spareTyre": spareTyre,
    "bootFloor": bootFloor,
    "rhsRearAlloy": rhsRearAlloy,
    "rhsRearTyre": rhsRearTyre,
    "rhsFrontAlloy": rhsFrontAlloy,
    "rhsFrontTyre": rhsFrontTyre,
    "rhsQuarterPanel": rhsQuarterPanel,
    "rhsAPillar": rhsAPillar,
    "rhsBPillar": rhsBPillar,
    "rhsCPillar": rhsCPillar,
    "rhsRunningBorder": rhsRunningBorder,
    "rhsRearDoor": rhsRearDoor,
    "rhsFrontDoor": rhsFrontDoor,
    "rhsOrvm": rhsOrvm,
    "rhsFender": rhsFender,
    "comments": comments,
    "frontMain": frontMain.map((x) => x).toList(),
    "bonnetImages": bonnetImages.map((x) => x).toList(),
    "frontWindshieldImages": frontWindshieldImages,
    "roofImages": roofImages,
    "frontBumperImages": frontBumperImages.map((x) => x).toList(),
    "lhsHeadlampImages": lhsHeadlampImages,
    "lhsFoglampImages": lhsFoglampImages,
    "rhsHeadlampImages": rhsHeadlampImages,
    "rhsFoglampImages": rhsFoglampImages,
    "lhsFront45Degree": lhsFront45Degree.map((x) => x).toList(),
    "lhsFenderImages": lhsFenderImages.map((x) => x).toList(),
    "lhsFrontAlloyImages": lhsFrontAlloyImages,
    "lhsFrontTyreImages": lhsFrontTyreImages.map((x) => x).toList(),
    "lhsRunningBorderImages": lhsRunningBorderImages.map((x) => x).toList(),
    "lhsOrvmImages": lhsOrvmImages,
    "lhsAPillarImages": lhsAPillarImages,
    "lhsFrontDoorImages": lhsFrontDoorImages.map((x) => x).toList(),
    "lhsBPillarImages": lhsBPillarImages,
    "lhsRearDoorImages": lhsRearDoorImages.map((x) => x).toList(),
    "lhsCPillarImages": lhsCPillarImages,
    "lhsRearTyreImages": lhsRearTyreImages.map((x) => x).toList(),
    "lhsRearAlloyImages": lhsRearAlloyImages,
    "lhsQuarterPanelImages": lhsQuarterPanelImages.map((x) => x).toList(),
    "rearMain": rearMain.map((x) => x).toList(),
    "rearWithBootDoorOpen": rearWithBootDoorOpen,
    "rearBumperImages": rearBumperImages.map((x) => x).toList(),
    "lhsTailLampImages": lhsTailLampImages,
    "rhsTailLampImages": rhsTailLampImages,
    "rearWindshieldImages": rearWindshieldImages,
    "spareTyreImages": spareTyreImages.map((x) => x).toList(),
    "bootFloorImages": bootFloorImages.map((x) => x).toList(),
    "rhsRear45Degree": rhsRear45Degree.map((x) => x).toList(),
    "rhsQuarterPanelImages": rhsQuarterPanelImages.map((x) => x).toList(),
    "rhsRearAlloyImages": rhsRearAlloyImages,
    "rhsRearTyreImages": rhsRearTyreImages,
    "rhsCPillarImages": rhsCPillarImages,
    "rhsRearDoorImages": rhsRearDoorImages.map((x) => x).toList(),
    "rhsBPillarImages": rhsBPillarImages,
    "rhsFrontDoorImages": rhsFrontDoorImages.map((x) => x).toList(),
    "rhsAPillarImages": rhsAPillarImages,
    "rhsRunningBorderImages": rhsRunningBorderImages.map((x) => x).toList(),
    "rhsFrontAlloyImages": rhsFrontAlloyImages,
    "rhsFrontTyreImages": rhsFrontTyreImages.map((x) => x).toList(),
    "rhsOrvmImages": rhsOrvmImages,
    "rhsFenderImages": rhsFenderImages.map((x) => x).toList(),
    "upperCrossMember": upperCrossMember,
    "radiatorSupport": radiatorSupport,
    "headlightSupport": headlightSupport,
    "lowerCrossMember": lowerCrossMember,
    "lhsApron": lhsApron,
    "rhsApron": rhsApron,
    "firewall": firewall,
    "cowlTop": cowlTop,
    "engine": engine,
    "battery": battery,
    "coolant": coolant,
    "engineOilLevelDipstick": engineOilLevelDipstick,
    "engineOil": engineOil,
    "engineMount": engineMount,
    "enginePermisableBlowBy": enginePermisableBlowBy,
    "exhaustSmoke": exhaustSmoke,
    "clutch": clutch,
    "gearShift": gearShift,
    "commentsOnEngine": commentsOnEngine,
    "commentsOnEngineOil": commentsOnEngineOil,
    "commentsOnTowing": commentsOnTowing,
    "commentsOnTransmission": commentsOnTransmission,
    "commentsOnRadiator": commentsOnRadiator,
    "commentsOnOthers": commentsOnOthers,
    "engineBay": engineBay.map((x) => x).toList(),
    "apronLhsRhs": apronLhsRhs.map((x) => x).toList(),
    "batteryImages": batteryImages.map((x) => x).toList(),
    "additionalImages": additionalImages,
    "engineSound": engineSound.map((x) => x).toList(),
    "exhaustSmokeImages": exhaustSmokeImages.map((x) => x).toList(),
    "steering": steering,
    "brakes": brakes,
    "suspension": suspension,
    "odometerReadingInKms": odometerReadingInKms,
    "fuelLevel": fuelLevel,
    "abs": abs,
    "electricals": electricals,
    "rearWiperWasher": rearWiperWasher,
    "rearDefogger": rearDefogger,
    "musicSystem": musicSystem,
    "stereo": stereo,
    "inbuiltSpeaker": inbuiltSpeaker,
    "externalSpeaker": externalSpeaker,
    "steeringMountedAudioControl": steeringMountedAudioControl,
    "noOfPowerWindows": noOfPowerWindows,
    "powerWindowConditionRhsFront": powerWindowConditionRhsFront,
    "powerWindowConditionLhsFront": powerWindowConditionLhsFront,
    "powerWindowConditionRhsRear": powerWindowConditionRhsRear,
    "powerWindowConditionLhsRear": powerWindowConditionLhsRear,
    "commentOnInterior": commentOnInterior,
    "noOfAirBags": noOfAirBags,
    "airbagFeaturesDriverSide": airbagFeaturesDriverSide,
    "airbagFeaturesCoDriverSide": airbagFeaturesCoDriverSide,
    "airbagFeaturesLhsAPillarCurtain": airbagFeaturesLhsAPillarCurtain,
    "airbagFeaturesLhsBPillarCurtain": airbagFeaturesLhsBPillarCurtain,
    "airbagFeaturesLhsCPillarCurtain": airbagFeaturesLhsCPillarCurtain,
    "airbagFeaturesRhsAPillarCurtain": airbagFeaturesRhsAPillarCurtain,
    "airbagFeaturesRhsBPillarCurtain": airbagFeaturesRhsBPillarCurtain,
    "airbagFeaturesRhsCPillarCurtain": airbagFeaturesRhsCPillarCurtain,
    "sunroof": sunroof,
    "leatherSeats": leatherSeats,
    "fabricSeats": fabricSeats,
    "commentsOnElectricals": commentsOnElectricals,
    "meterConsoleWithEngineOn": meterConsoleWithEngineOn.map((x) => x).toList(),
    "airbags": airbags.map((x) => x).toList(),
    "sunroofImages": sunroofImages,
    "frontSeatsFromDriverSideDoorOpen":
        frontSeatsFromDriverSideDoorOpen.map((x) => x).toList(),
    "rearSeatsFromRightSideDoorOpen":
        rearSeatsFromRightSideDoorOpen.map((x) => x).toList(),
    "dashboardFromRearSeat": dashboardFromRearSeat.map((x) => x).toList(),
    "reverseCamera": reverseCamera,
    "additionalImages2": additionalImages2,
    "airConditioningManual": airConditioningManual,
    "airConditioningClimateControl": airConditioningClimateControl,
    "commentsOnAC": commentsOnAc,
    "approvedBy": approvedBy,
    "approvalDate": approvalDate,
    "approvalTime": approvalTime,
    "approvalStatus": approvalStatus,
    "contactNumber": contactNumber,
    "newArrivalMessage": newArrivalMessage,
    "budgetCar": budgetCar,
    "status": status,
    "priceDiscovery": priceDiscovery,
    "priceDiscoveryBy": priceDiscoveryBy,
    "latlong": latlong,
    "retailAssociate": retailAssociate,
    "kmRangeLevel": kmRangeLevel,
    "highestBidder": highestBidder,
    "__v": v,
  };
}

DateTime? parseMongoDbDate(dynamic v) {
  try {
    if (v == null) return null;

    // 1) ISO string: "2025-08-11T10:50:00.000Z" or "+00:00" or no offset
    if (v is String) {
      // numeric string? treat as epoch ms
      final maybeNum = int.tryParse(v);
      if (maybeNum != null) {
        return DateTime.fromMillisecondsSinceEpoch(
          maybeNum,
          isUtc: true,
        ).toLocal();
      }

      final dt = DateTime.parse(
        v,
      ); // Dart sets isUtc=true if Z or +/-offset present
      return dt.isUtc ? dt.toLocal() : dt; // normalize to local
    }

    // 2) Epoch milliseconds (int)
    if (v is int) {
      return DateTime.fromMillisecondsSinceEpoch(v, isUtc: true).toLocal();
    }

    // 3) Extended JSON: {"$date": "..."} or {"$date": 1723363800000} or {"$date":{"$numberLong":"..."}}
    if (v is Map) {
      final raw = v[r'$date'];
      if (raw == null) return null;

      if (raw is String) {
        // could be ISO or numeric string
        final maybeNum = int.tryParse(raw);
        if (maybeNum != null) {
          return DateTime.fromMillisecondsSinceEpoch(
            maybeNum,
            isUtc: true,
          ).toLocal();
        }
        final dt = DateTime.parse(raw);
        return dt.isUtc ? dt.toLocal() : dt;
      }

      if (raw is int) {
        return DateTime.fromMillisecondsSinceEpoch(raw, isUtc: true).toLocal();
      }

      if (raw is Map && raw[r'$numberLong'] != null) {
        final ms = int.tryParse(raw[r'$numberLong'].toString());
        if (ms != null) {
          return DateTime.fromMillisecondsSinceEpoch(ms, isUtc: true).toLocal();
        }
      }
    }
  } catch (e) {
    // optional: debugPrint('parseMongoDbDate error: $e  (value: $v)');
  }
  return null;
}

// DateTime? parseMongoDbDate(dynamic dateJson) {
//   try {
//     if (dateJson == null) return null;

//     if (dateJson is String) {
//       return DateTime.tryParse(dateJson);
//     }

//     if (dateJson is Map<String, dynamic> && dateJson['\$date'] is String) {
//       return DateTime.tryParse(dateJson['\$date']);
//     }

//     if (dateJson is Map<String, dynamic> &&
//         dateJson['\$date'] is Map<String, dynamic>) {
//       final millisStr = dateJson['\$date']['\$numberLong'];
//       final millis = int.tryParse(millisStr ?? '');
//       return millis != null
//           ? DateTime.fromMillisecondsSinceEpoch(millis)
//           : null;
//     }
//   } catch (e) {
//     print('parseMongoDbDate error: $e');
//   }

//   return null;
// }

List<String> parseStringList(dynamic value) {
  if (value == null) return [];
  if (value is List) return value.map((e) => e.toString()).toList();
  //   if (value is String) return [value];
  if (value is String && value.trim().isNotEmpty) return [value];
  return [];
}
