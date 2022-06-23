Class {
	#name : #GtJsonSimplePersonModel,
	#superclass : #GtJsonDictionaryModel,
	#category : #'GToolkit4Json-Examples'
}

{ #category : #accessing }
GtJsonSimplePersonModel >> address [

	^ self valueAt: #address
]

{ #category : #accessing }
GtJsonSimplePersonModel >> address: anAddress [

	self valueAt: #address put: anAddress
]

{ #category : #accessing }
GtJsonSimplePersonModel >> birthday [

	^ self valueAt: #birthday
]

{ #category : #accessing }
GtJsonSimplePersonModel >> birthday: aDate [

	self valueAt: #birthday put: aDate
]

{ #category : #accessing }
GtJsonSimplePersonModel >> familyName [

	^ self valueAt: #familyName
]

{ #category : #accessing }
GtJsonSimplePersonModel >> familyName: aString [

	self valueAt: #familyName put: aString
]

{ #category : #accessing }
GtJsonSimplePersonModel >> firstName [

	^ self valueAt: #firstName
]

{ #category : #accessing }
GtJsonSimplePersonModel >> firstName: aString [

	self valueAt: #firstName put: aString
]

{ #category : #accessing }
GtJsonSimplePersonModel >> jsonModelDefinition [

	^ { 
		  (GtJsonStringModel key: #firstName at: self defaultValue: '').
		  (GtJsonStringModel key: #familyName at: self defaultValue: '').
		  (GtJsonDateModel key: #birthday at: self defaultValue: nil).
		  (GtJsonPostalAdressModel key: #address at: self defaultValue: nil) }
]
