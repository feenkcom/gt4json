Class {
	#name : #GtJsonPersonKeyedAddressesModel,
	#superclass : #GtJsonDictionaryModel,
	#category : #'GToolkit4Json-Examples'
}

{ #category : #accessing }
GtJsonPersonKeyedAddressesModel >> addresses [

	^ self valueAt: #addresses
]

{ #category : #accessing }
GtJsonPersonKeyedAddressesModel >> addresses: aCollection [

	self valueAt: #addresses put: aCollection
]

{ #category : #accessing }
GtJsonPersonKeyedAddressesModel >> birthday [

	^ self valueAt: #birthday
]

{ #category : #accessing }
GtJsonPersonKeyedAddressesModel >> birthday: aDate [

	self valueAt: #birthday put: aDate
]

{ #category : #accessing }
GtJsonPersonKeyedAddressesModel >> familyName [

	^ self valueAt: #familyName
]

{ #category : #accessing }
GtJsonPersonKeyedAddressesModel >> familyName: aString [

	self valueAt: #familyName put: aString
]

{ #category : #accessing }
GtJsonPersonKeyedAddressesModel >> firstName [

	^ self valueAt: #firstName
]

{ #category : #accessing }
GtJsonPersonKeyedAddressesModel >> firstName: aString [

	self valueAt: #firstName put: aString
]

{ #category : #accessing }
GtJsonPersonKeyedAddressesModel >> jsonModelDefinition [

	^ { 
		  (GtJsonStringModel key: #firstName at: self defaultValue: '').
		  (GtJsonStringModel key: #familyName at: self defaultValue: '').
		  (GtJsonDateModel key: #birthday at: self defaultValue: nil).
		  (GtJsonPostalAdressModel
			   dictionariesKey: #addresses
			   at: self
			   defaultValue: nil) }
]

{ #category : #printing }
GtJsonPersonKeyedAddressesModel >> printOn: aStream [
	super printOn: aStream.

	aStream
		nextPut: $(;
		nextPutAll: self firstName asString;
		space;
		nextPutAll: self familyName asString;
		nextPut: $)
]
