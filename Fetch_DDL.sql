CREATE Table UsersData (
 userId NVARCHAR(50)
	active BOOLEAN
	role VARCHAR(50)
	signUpSource VARCHAR(50)
	state VARCHAR(50)
	createdDate NVARCHAR(50)
	lastLoginDate NVARCHAR(50)
	CONSTRAINT [PK_UserId] PRIMARY KEY  ([UserId])
  );

 CREATE Table Brands (
 barcode integer
	category VARCHAR(50)
	categoryCode VARCHAR(50)
	name VARCHAR(64)
	topBrand BOOLEAN
	brand_id NVARCHAR(50)
	cpgid NVARCHAR(50)
	cpgref VARCHAR(50)
	brandCode VARCHAR(50)
	CONSTRAINT [PK_barcode] PRIMARY KEY  ([Barcode]
  );

CREATE TABLE "Receipts" (
	bonusPointsEarned INTEGER,
	bonusPointsEarnedReason VARCHAR(128),
	pointsEarned REAL,
	purchasedItemCount INTEGER,
	barcode INTEGER,
	description VARCHAR(256),
	finalPrice REAL,
	itemPrice REAL,
	needsFetchReview BOOLEAN,
	partnerItemId INTEGER,
	preventTargetGapPoints BOOLEAN,
	quantityPurchased INTEGER,
	userFlaggedBarcode INTEGER,
	userFlaggedNewItem BOOLEAN,
	userFlaggedPrice REAL,
	userFlaggedQuantity INTEGER,
	needsFetchReviewReason VARCHAR(50),
	pointsNotAwardedReason VARCHAR(50),
	pointsPayerId NVARCHAR(50),
	rewardsGroup VARCHAR(64),
	rewardsProductPartnerId NVARCHAR(50),
	userFlaggedDescription VARCHAR(64),
	originalMetaBriteBarcode INTEGER,
	originalMetaBriteDescription VARCHAR(64),
	brandCode VARCHAR(50),
	competitorRewardsGroup VARCHAR(50),
	discountedItemPrice REAL,
	originalReceiptItemText VARCHAR(256),
	itemNumber INTEGER,
	originalMetaBriteQuantityPurchased INTEGER,
	"pointsEarned.1" REAL,
	targetPrice INTEGER,
	competitiveProduct BOOLEAN,
	originalFinalPrice REAL,
	deleted BOOLEAN,
	priceAfterCoupon REAL,
	metabriteCampaignId VARCHAR(64),
	rewardsReceiptStatus VARCHAR(50),
	totalSpent REAL,
	userId NVARCHAR(50),
	"_id.$oid" NVARCHAR(50),
	"createDate" NVARCHAR(50),
	"dateScanned" NVARCHAR(50),
	"finishedDate" NVARCHAR(50),
	"modifyDate" NVARCHAR(50),
	"pointsAwardedDate" NVARCHAR(50),
	"purchaseDate" NVARCHAR(50),
	 FOREIGN KEY ([UserId]) REFERENCES [UserData] ([UserId]),
	 FOREIGN KEY ([barcode]) REFERENCES [Brands] ([barcode]) 
	
);