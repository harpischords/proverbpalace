@tool
extends EditorScript

const MIRROR_CHARS_HORIZONTAL = [
	"bd","oo","vv","ww","88",# "pq"    #,"Ԑ3"
]
const MIRROR_CHARS_180 = [
	"69", "ss", "88", "oo", "dp", "mw"#, "bq"
]


func get_mirrored_ngram(ngram: String,mirror_set: Array[String]):
	var output := ""
	
	for let in ngram:
		for mirroring in mirror_set:
			if let in mirroring:
				var i = 1-mirroring.find(let)
				output += mirroring[i]
	return output.reverse()
func get_bigram_permutations(
	combo_a: String, combo_b: String
) -> Array[String]:
	var dict: Dictionary[String,bool] = {}
	
	for ind_a in range(2):
		for ind_b in range(2):
			var s = combo_a[ind_a] + combo_b[ind_b]
			dict[s] = true
			dict[s.reverse()] = true
				
	return dict.keys()

func has_any_number(s: String):
	for let in s:
		if let in Letters.NUMBERS:
			return true
	return false
	

func _run() -> void:
	var valid_mirror_pairings = []
	var valid_permutations = [{},{}]
	
	var i = 0
	for mirror_set in [MIRROR_CHARS_180, MIRROR_CHARS_HORIZONTAL]:
		for mirroring_a in mirror_set:
			for mirroring_b in mirror_set:
				var permutations = get_bigram_permutations(mirroring_a,mirroring_b)
		
				var valid = true
				for p in permutations:
					if p not in Letters.BIGRAMS and !(has_any_number(p)):
						valid = false
						break
				if !valid:
					continue
				for p in permutations:
					valid_permutations[i][p] = true
				valid_mirror_pairings.append([mirroring_a,mirroring_b])
		i += 1
	for d in valid_permutations:
		print(d.keys())
