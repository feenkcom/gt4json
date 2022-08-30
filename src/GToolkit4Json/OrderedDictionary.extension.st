Extension { #name : #OrderedDictionary }

{ #category : #'*GToolkit4Json' }
OrderedDictionary >> asJson [

	^ GtJson forJsonObject: self
]

{ #category : #'*GToolkit4Json' }
OrderedDictionary >> gtJsonValueDisplayText [
	^ self size gtDisplayText
		append: (' properties' asPluralBasedOn: self size) gtDisplayText;
		foreground: BrGlamorousColors disabledButtonTextColor
]
