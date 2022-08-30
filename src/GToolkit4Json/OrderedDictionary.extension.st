Extension { #name : #OrderedDictionary }

{ #category : #'*GToolkit4Json' }
OrderedDictionary >> asJson [

	^ GtJson forJsonObject: self
]

{ #category : #'*GToolkit4Json' }
OrderedDictionary >> gtJsonValueDisplayText [
	^ self size gtDisplayText
		append: (self size = 1
				ifTrue: [ 'property' gtDisplayText ]
				ifFalse: [ ' properties' gtDisplayText ]);
		foreground: BrGlamorousColors disabledButtonTextColor
]
