Extension { #name : #Dictionary }

{ #category : #'*GToolkit4Json' }
Dictionary >> asJson [

	^ GtJson forJsonObject: self
]

{ #category : #'*GToolkit4Json' }
Dictionary >> gtJsonValueDisplayText [
	^ self size gtDisplayText
		append: (self size = 1
				ifTrue: [ 'property' gtDisplayText ]
				ifFalse: [ ' properties' gtDisplayText ]);
		foreground: BrGlamorousColors disabledButtonTextColor
]
