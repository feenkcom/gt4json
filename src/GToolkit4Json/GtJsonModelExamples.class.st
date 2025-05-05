Class {
	#name : #GtJsonModelExamples,
	#superclass : #Object,
	#category : #'GToolkit4Json-Examples'
}

{ #category : #'examples - address' }
GtJsonModelExamples >> anotherAddressJson [
	<gtExample>
	<return: #GtJsonIndex>
	| aPerson anAddress aBoolean |
	aPerson := self personJson.
	anAddress := aPerson atPath: #(#addresses 1).
	aBoolean := anAddress at: #is_primary.

	self assert: aBoolean exists not.

	^ anAddress
]

{ #category : #'examples - address' }
GtJsonModelExamples >> anotherAddressModel_JsonValues [
	<gtExample>
	<return: #GtJsonPostalAdressModel>
	| aJson anAddress |
	aJson := self anotherAddressJson.
	anAddress := self emptyAddressModel.
	anAddress json: aJson.

	self assert: anAddress json equals: aJson.

	self assert: anAddress street equals: 'Kopernikova 345'.
	self assert: anAddress city equals: 'Bratislava'.
	self assert: anAddress isPrimary not description: 'Address must NOT be primary'.

	^ anAddress
]

{ #category : #'examples - address' }
GtJsonModelExamples >> emptyAddressModel [
	<gtExample>
	<return: #GtJsonPostalAdressModel>
	| anAddress |
	anAddress := GtJsonPostalAdressModel new.

	^ anAddress
]

{ #category : #'examples - date and time' }
GtJsonModelExamples >> emptyDateAndTimeModel [
	<gtExample>
	<return: #GtJsonDateAndTimeModel>
	| aModel |
	aModel := GtJsonDateAndTimeModel new.

	self assert: aModel valueExists not.
	self assert: aModel jsonExists not.

	^ aModel
]

{ #category : #'examples - person' }
GtJsonModelExamples >> emptyPersonKeyedAddressesModel [
	<gtExample>
	<return: #GtJsonPersonKeyedAddressesModel>
	| aPerson |
	aPerson := GtJsonPersonKeyedAddressesModel new.

	^ aPerson
]

{ #category : #'examples - person' }
GtJsonModelExamples >> emptyPersonModel [
	<gtExample>
	<return: #GtJsonPersonModel>
	| aPerson |
	aPerson := GtJsonPersonModel new.

	^ aPerson
]

{ #category : #'examples - persons' }
GtJsonModelExamples >> emptyPersonsModel [
	<gtExample>
	<return: #GtJsonPersonsModel>
	| aPerson |
	aPerson := GtJsonPersonsModel new.

	^ aPerson
]

{ #category : #'examples - simple person' }
GtJsonModelExamples >> emptySimplePersonModel [
	<gtExample>
	<return: #GtJsonSimplePersonModel>
	| aPerson |
	aPerson := GtJsonSimplePersonModel new.

	^ aPerson
]

{ #category : #'examples - simple person' }
GtJsonModelExamples >> emptySimplePersonModelWithoutAccessors [
	<gtExample>
	<return: #GtJsonSimplePersonModelWithoutAccessors>
	| aPerson |
	aPerson := GtJsonSimplePersonModelWithoutAccessors new.

	^ aPerson
]

{ #category : #'examples - date and time' }
GtJsonModelExamples >> invalidDateAndTimeModel [
	<gtExample>
	<return: #GtJsonDateAndTimeModel>
	| aModel |
	aModel := GtJsonDateAndTimeModel forJsonString: '"2010-01-01T19:73:24Z"'.

	self assert: aModel valueExists not.
	self assert: aModel jsonExists.

	^ aModel
]

{ #category : #'examples - date and time' }
GtJsonModelExamples >> missingDateAndTimeModel [
	<gtExample>
	<return: #GtJsonDateAndTimeModel>
	| aModel aRootJson aDateJson |
	aRootJson := GtJson forJsonObject: #() asDictionary.
	aDateJson := aRootJson at: #date.

	aModel := GtJsonDateAndTimeModel forJson: aDateJson.

	self assert: aModel valueExists not.
	self assert: aModel jsonExists not.

	^ aModel
]

{ #category : #'examples - person' }
GtJsonModelExamples >> personJson [
	<gtExample>
	<return: #GtJson>
	^ GtJsonExamples new personJson
]

{ #category : #'examples - person' }
GtJsonModelExamples >> personKeyedAddressesJson [
	<gtExample>
	<return: #GtJson>
	^ GtJsonExamples new personKeyedAddressesJson
]

{ #category : #'examples - person' }
GtJsonModelExamples >> personKeyedAddressesModel_ExplicitValue [
	<gtExample>
	<return: #GtJsonPersonKeyedAddressesModel>
	| aPerson |
	aPerson := self emptyPersonKeyedAddressesModel.

	aPerson firstName: 'Joe'.
	aPerson familyName: 'Doe'.
	aPerson birthday: '12 June 2001' asDate.

	aPerson addresses home: self primaryAddressModel_ExplicitValues.
	aPerson addresses work: self anotherAddressModel_JsonValues.

	self assert: aPerson firstName equals: 'Joe'.
	self assert: aPerson familyName equals: 'Doe'.
	self assert: aPerson birthday equals: '12 June 2001' asDate.
	self assert: aPerson addresses size equals: 2.

	self assert: aPerson addresses home street equals: 'Kostelní 12'.
	self assert: aPerson addresses work street equals: 'Kopernikova 345'.

	^ aPerson
]

{ #category : #'examples - person' }
GtJsonModelExamples >> personKeyedAddressesModel_JsonValue [
	<gtExample>
	<return: #GtJsonPersonKeyedAddressesModel>
	| aJson aPerson |
	aJson := self personKeyedAddressesJson.
	aPerson := self emptyPersonKeyedAddressesModel.
	aPerson json: aJson.

	self assert: aPerson firstName equals: 'Joe'.
	self assert: aPerson familyName equals: 'Doe'.
	self assert: aPerson birthday equals: '12 June 2001' asDate.
	self assert: aPerson addresses size equals: 2.

	self assert: aPerson addresses home street equals: 'Kopernikova 345'.

	^ aPerson
]

{ #category : #'examples - person' }
GtJsonModelExamples >> personModel_ExplicitValue [
	<gtExample>
	<return: #GtJsonPersonModel>
	| aPerson |
	aPerson := self emptyPersonModel.

	aPerson firstName: 'Joe'.
	aPerson familyName: 'Doe'.
	aPerson birthday: '12 June 2001' asDate.

	aPerson
		addresses: {self primaryAddressModel_ExplicitValues.
				self anotherAddressModel_JsonValues}.

	self assert: aPerson firstName equals: 'Joe'.
	self assert: aPerson familyName equals: 'Doe'.
	self assert: aPerson birthday equals: '12 June 2001' asDate.
	self assert: aPerson addresses size equals: 2.

	^ aPerson
]

{ #category : #'examples - person' }
GtJsonModelExamples >> personModel_JsonValue [
	<gtExample>
	<return: #GtJsonPersonModel>
	| aJson aPerson |
	aJson := self personJson.
	aPerson := self emptyPersonModel.
	aPerson json: aJson.

	self assert: aPerson firstName equals: 'Joe'.
	self assert: aPerson familyName equals: 'Doe'.
	self assert: aPerson birthday equals: '12 June 2001' asDate.
	self assert: aPerson addresses size equals: 2.

	^ aPerson
]

{ #category : #'examples - person' }
GtJsonModelExamples >> personsJson [
	<gtExample>
	<return: #GtJson>
	^ GtJsonExamples new personsJson
]

{ #category : #'examples - persons' }
GtJsonModelExamples >> personsModel_JsonValue [
	<gtExample>
	<return: #GtJsonPersonsModel>
	| aPersons |
	aPersons := self emptyPersonsModel.

	aPersons
		items: {self personModel_ExplicitValue.
				self personModel_JsonValue}.

	self assert: aPersons size equals: 2.
	self assert: (aPersons modelAt: 1) firstName equals: 'Joe'.
	self assert: (aPersons modelAt: 1) familyName equals: 'Doe'.
	self assert: (aPersons modelAt: 1) birthday equals: '12 June 2001' asDate.
	self assert: (aPersons modelAt: 1) addresses size equals: 2.

	^ aPersons
]

{ #category : #'examples - address' }
GtJsonModelExamples >> primaryAddressJson [
	<gtExample>
	<return: #GtJsonIndex>
	| aPerson anAddress aBoolean |
	aPerson := self personJson.
	anAddress := aPerson atPath: #(#addresses 2).
	aBoolean := anAddress at: #is_primary.

	self assert: aBoolean exists.
	self assert: aBoolean jsonObject equals: true.

	^ anAddress
]

{ #category : #'examples - address' }
GtJsonModelExamples >> primaryAddressModel_ExplicitValues [
	<gtExample>
	<return: #GtJsonPostalAdressModel>
	| anAddress |
	anAddress := self emptyAddressModel.

	anAddress street: 'Kostelní 12'.
	anAddress city: 'Hradec Králové'.

	self assert: anAddress street equals: 'Kostelní 12'.
	self assert: anAddress city equals: 'Hradec Králové'.
	self assert: anAddress isPrimary not description: 'Address must NOT be primary'.

	anAddress isPrimary: true.
	self assert: anAddress isPrimary description: 'Address must be primary'.

	^ anAddress
]

{ #category : #'examples - address' }
GtJsonModelExamples >> primaryAddressModel_JsonValues [
	<gtExample>
	<return: #GtJsonPostalAdressModel>
	| aJson anAddress |
	aJson := self primaryAddressJson.
	anAddress := self emptyAddressModel.
	anAddress json: aJson.

	self assert: anAddress json equals: aJson.

	self assert: anAddress street equals: 'Havlova 89'.
	self assert: anAddress city equals: 'Praha'.
	self assert: anAddress isPrimary description: 'Address must be primary'.

	^ anAddress
]

{ #category : #'examples - person' }
GtJsonModelExamples >> simplePersonJson [
	<gtExample>
	<return: #GtJson>
	^ GtJsonExamples new simplePersonJsonObject asGtJson
]

{ #category : #'examples - simple person' }
GtJsonModelExamples >> simplePersonModelWithouAccessors_JsonValues [
	<gtExample>
	<return: #GtJsonSimplePersonModel>
	| aPerson aJson |
	aJson := self simplePersonJson.
	aPerson := self emptySimplePersonModel.

	aPerson json: aJson.

	self assert: aPerson firstName equals: 'Joe'.
	self assert: aPerson familyName equals: 'Doe'.
	self assert: aPerson birthday equals: '12 June 2001' asDate.
	self assert: aPerson address street equals: 'Kopernikova 345'.
	self assert: aPerson address city equals: 'Bratislava'.

	^ aPerson
]

{ #category : #'examples - simple person' }
GtJsonModelExamples >> simplePersonModelWithoutAccessors_ExplicitValue [
	<gtExample>
	<return: #GtJsonSimplePersonModelWithoutAccessors>
	| aPerson anAddress |
	aPerson := self emptySimplePersonModelWithoutAccessors.

	aPerson firstName: 'Joe'.
	aPerson familyName: 'Doe'.
	aPerson birthday: '12 June 2001' asDate.
	anAddress := self primaryAddressModel_ExplicitValues.

	aPerson address: anAddress.

	self assert: aPerson firstName equals: 'Joe'.
	self assert: aPerson familyName equals: 'Doe'.
	self assert: aPerson birthday equals: '12 June 2001' asDate.
	self assert: aPerson address equals: anAddress.

	^ aPerson
]

{ #category : #'examples - simple person' }
GtJsonModelExamples >> simplePersonModelWithoutAccessors_JsonValues [
	<gtExample>
	<return: #GtJsonSimplePersonModelWithoutAccessors>
	| aPerson aJson |
	aJson := self simplePersonJson.
	aPerson := self emptySimplePersonModelWithoutAccessors.

	aPerson json: aJson.

	self assert: aPerson firstName equals: 'Joe'.
	self assert: aPerson familyName equals: 'Doe'.
	self assert: aPerson birthday equals: '12 June 2001' asDate.
	self assert: aPerson address street equals: 'Kopernikova 345'.
	self assert: aPerson address city equals: 'Bratislava'.

	[ aPerson nonExistingMethod.
	self
		assert: false
		description: [ MessageNotUnderstood name , ' exception is expected' ] ]
		on: MessageNotUnderstood
		do: [ :anError "an expected error" |  ].

	^ aPerson
]

{ #category : #'examples - simple person' }
GtJsonModelExamples >> simplePersonModel_ExplicitValue [
	<gtExample>
	<return: #GtJsonSimplePersonModel>
	| aPerson anAddress |
	aPerson := self emptySimplePersonModel.

	aPerson firstName: 'Joe'.
	aPerson familyName: 'Doe'.
	aPerson birthday: '12 June 2001' asDate.
	anAddress := self primaryAddressModel_ExplicitValues.

	aPerson address: anAddress.

	self assert: aPerson firstName equals: 'Joe'.
	self assert: aPerson familyName equals: 'Doe'.
	self assert: aPerson birthday equals: '12 June 2001' asDate.
	self assert: aPerson address equals: anAddress.

	^ aPerson
]

{ #category : #'examples - simple person' }
GtJsonModelExamples >> simplePersonModel_JsonValues [
	<gtExample>
	<return: #GtJsonSimplePersonModel>
	| aPerson aJson |
	aJson := self simplePersonJson.
	aPerson := self emptySimplePersonModel.

	aPerson json: aJson.

	self assert: aPerson firstName equals: 'Joe'.
	self assert: aPerson familyName equals: 'Doe'.
	self assert: aPerson birthday equals: '12 June 2001' asDate.
	self assert: aPerson address street equals: 'Kopernikova 345'.
	self assert: aPerson address city equals: 'Bratislava'.

	^ aPerson
]

{ #category : #'examples - date and time' }
GtJsonModelExamples >> validDateAndTimeModel [
	<gtExample>
	<return: #GtJsonDateAndTimeModel>
	| aModel |
	aModel := GtJsonDateAndTimeModel forJsonString: '"2010-01-01T19:53:24Z"'.

	self assert: aModel valueExists.
	self assert: aModel jsonExists.

	^ aModel
]
