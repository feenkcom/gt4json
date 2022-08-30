Extension { #name : #Dictionary }

{ #category : #'*GToolkit4Json' }
Dictionary >> asJson [

	^ GtJson forJsonObject: self
]

{ #category : #'*GToolkit4Json' }
Dictionary >> gtJsonValueDisplayText [
	^ self size gtDisplayText
		append: (' properties' asPluralBasedOn: self size) gtDisplayText;
		foreground: BrGlamorousColors disabledButtonTextColor
]
