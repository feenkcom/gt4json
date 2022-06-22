Class {
	#name : #GtJsonPersonModel,
	#superclass : #GtJsonDictionaryModel,
	#category : #'GToolkit4Json-Examples'
}

{ #category : #accessing }
GtJsonPersonModel >> addresses [

	^ self valueAt: #addresses
]

{ #category : #accessing }
GtJsonPersonModel >> addresses: aCollection [

	self valueAt: #addresses put: aCollection
]

{ #category : #accessing }
GtJsonPersonModel >> birthday [

	^ self valueAt: #birthday
]

{ #category : #accessing }
GtJsonPersonModel >> birthday: aDate [

	self valueAt: #birthday put: aDate
]

{ #category : #accessing }
GtJsonPersonModel >> familyName [

	^ self valueAt: #familyName
]

{ #category : #accessing }
GtJsonPersonModel >> familyName: aString [

	self valueAt: #familyName put: aString
]

{ #category : #accessing }
GtJsonPersonModel >> firstName [

	^ self valueAt: #firstName
]

{ #category : #accessing }
GtJsonPersonModel >> firstName: aString [

	self valueAt: #firstName put: aString
]

{ #category : #accessing }
GtJsonPersonModel >> jsonModelDefinition [

	^ { 
		  (GtJsonStringModel key: #firstName at: self defaultValue: '').
		  (GtJsonStringModel key: #familyName at: self defaultValue: '').
		  (GtJsonDateModel key: #birthday at: self defaultValue: nil).
		  (GtJsonPostalAdressModel
			   listKey: #addresses
			   at: self
			   defaultValue: #(  )) }
]

{ #category : #printing }
GtJsonPersonModel >> printOn: aStream [
	super printOn: aStream.

	aStream
		nextPut: $(;
		nextPutAll: self firstName asString;
		space;
		nextPutAll: self familyName asString;
		nextPut: $)
]
