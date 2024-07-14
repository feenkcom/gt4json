Extension { #name : #OrderedDictionary }

{ #category : #'*GToolkit4Json' }
OrderedDictionary >> asGtJson [

	^ GtJson forJsonObject: self
]

{ #category : #'*GToolkit4Json' }
OrderedDictionary >> asJson [
	self
		deprecated: 'Please use #asGtJson instead.'
		transformWith: '`@receiver asJson' -> '`@receiver asGtJson'.
		
	^ self asGtJson
]

{ #category : #'*GToolkit4Json' }
OrderedDictionary >> gtJsonValueDisplayText [
	^ self size gtDisplayText
		append: (self size = 1
				ifTrue: [ ' property' gtDisplayText ]
				ifFalse: [ ' properties' gtDisplayText ]);
		foreground: BrGlamorousColors disabledButtonTextColor
]
