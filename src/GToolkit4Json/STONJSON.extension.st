Extension { #name : #STONJSON }

{ #category : #'*GToolkit4Json' }
STONJSON class >> jsonFromString: string [

	^ GtJson forJsonObject: (self fromString: string)
]
