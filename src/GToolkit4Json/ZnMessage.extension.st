Extension { #name : #ZnMessage }

{ #category : #'*GToolkit4Json' }
ZnMessage >> asJson [
	^ GtJson forJsonString: self contents
]
