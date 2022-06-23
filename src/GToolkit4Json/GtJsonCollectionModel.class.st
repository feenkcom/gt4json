Class {
	#name : #GtJsonCollectionModel,
	#superclass : #GtJsonModel,
	#instVars : [
		'models'
	],
	#category : #'GToolkit4Json-Model'
}

{ #category : #accessing }
GtJsonCollectionModel >> createModelAt: anIndex [

	| aDefinition aJson aModel |
	aDefinition := self jsonModelDefinition.

	self json ifNil: [ 
		| aValue |
		aValue := aDefinition ifNotNil: #defaultValue.
		^ GtJsonLeafModel new value: aValue ].

	aJson := self json at: anIndex.
	(aJson exists not and: [ aDefinition isNil ]) ifTrue: [ 
		^ GtJsonLeafModel new value: nil ].

	aDefinition ifNil: [ 
		aModel := GtJsonLeafModel forJson: aJson.
		self modelAt: anIndex put: aModel.
		^ aModel ].

	aModel := aDefinition createModelForJson: aJson.
	self modelAt: anIndex put: aModel.
	^ aModel
]

{ #category : #'gt - extensions' }
GtJsonCollectionModel >> gtJsonModelDefinitionFor: aView [

	<gtView>
	^ aView columnedTree
		  title: 'Structure';
		  priority: 60;
		  items: [ self jsonModelDefinition  asCollection ];
		  children: [ :anItem | anItem jsonModelDefinition asCollection ];
		  column: 'Key' text: #key weight: 1.5;
		  column: 'Value' text: [ :aDefinition | 
			  aDefinition valueDo: [ :aValue :isDefault | 
					  isDefault
						  ifFalse: [ aValue ]
						  ifTrue: [ 
							  aValue asRopedText foreground:
									  BrGlamorousColors disabledButtonTextColor ] ] ];
		  column: 'Type' text: #modelClass;
		  send: [ :aDefinition | aDefinition valueDo: [ :aValue | aValue ] ];
		  actionUpdateButton
]

{ #category : #'gt - extensions' }
GtJsonCollectionModel >> gtModelChildren [

	^ self models associations
]

{ #category : #'gt - extensions' }
GtJsonCollectionModel >> gtModelsFor: aView [

	<gtView>
	^ aView columnedList
		  title: 'Models';
		  priority: 65;
		  items: [ self gtModelChildren ];
		  column: 'Key' text: #key;
		  column: 'Value' text: [ :anAssoc | anAssoc value value ] weight: 3;
		  send: #value;
		  actionUpdateButton;
		  actionButtonIcon: BrGlamorousIcons trash
		  tooltip: 'Remove models'
		  action: [ :aButton :aTab | 
			  models := nil.
			  aTab viewContentElement phlow update ]
]

{ #category : #accessing }
GtJsonCollectionModel >> items: aCollection [
	aCollection
		withIndexDo: [ :aModel :anIndex | self models at: anIndex put: aModel ]
]

{ #category : #accessing }
GtJsonCollectionModel >> jsonModelDefinition [
	"Collection can have only one definition. 
	We therefore return the definition instead of a collection 
	as it is common in the dictionary model."
	^ GtJsonLeafModel list: self defaultValue: #()
]

{ #category : #accessing }
GtJsonCollectionModel >> modelAt: aKey [

	^ self models
		  at: aKey
		  ifAbsent: [ self createModelAt: aKey ]
]

{ #category : #accessing }
GtJsonCollectionModel >> modelAt: aKey put: aValue [
	self models at: aKey put: aValue
]

{ #category : #accessing }
GtJsonCollectionModel >> models [
	^ models ifNil: [ models := Dictionary new ]
]

{ #category : #printing }
GtJsonCollectionModel >> printOn: aStream [
	super printOn: aStream.

	aStream
		space;
		nextPut: $[;
		print: self size;
		nextPutAll: (' item' asPluralBasedOn: self size);
		nextPut: $]
]

{ #category : #accessing }
GtJsonCollectionModel >> size [
	self json ifNotNil: [ :aJson | ^ aJson jsonObject size ].
	^ models ifNotNil: #size ifNil: [ 0 ]
]
