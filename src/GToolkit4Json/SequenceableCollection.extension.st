Extension { #name : #SequenceableCollection }

{ #category : #'*GToolkit4Json' }
SequenceableCollection >> asJson [

	^ GtJson forJsonObject: self
]
