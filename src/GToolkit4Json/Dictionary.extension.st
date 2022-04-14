Extension { #name : #Dictionary }

{ #category : #'*GToolkit4Json' }
Dictionary >> asJson [

	^ GtJson forJsonObject: self
]
