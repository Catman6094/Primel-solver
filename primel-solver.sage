import time
import itertools as itools
from copy import deepcopy
start = time.time()

digit_count = 5
game_type = "PRIMES"

# PRIMES
candidates = list(map(str, filter(lambda x: is_prime(x) and len(set(x.digits())) == digit_count, (10^(digit_count - 1)..10^digit_count))))

# SQUARES
# candidates = list(map(str, filter(is_square, (10^(digit_count - 1)..10^digit_count - 1))))

def get_result(guess, answer):
	result = [""] * digit_count
	for i in range(len(guess)):
		d = guess[i]
		if d == answer[i]:
			result[i] = "X"

	remaining = list(filter(lambda x: result[x] == "", [0..len(result) - 1]))
	guess_remaining = [guess[i] for i in remaining]
	answer_remaining = [answer[i] for i in remaining]
	for i in range(len(remaining)):
		pos = remaining[i]
		c = guess[pos]
		if answer_remaining.count(c) >= guess_remaining[:i+1].count(c):
			result[pos] = "?"
		else: result[pos] = "_"
	return list(itools.accumulate(result))[-1]


def possible_results(guess, cands):
	results = {}
	for c in cands:
		result = get_result(guess, c)
		if result not in results:
			results[result] = 0
		results[result] += 1
	return results


def entropy(guess, cands):
	results = possible_results(guess, cands)

	cand_count = len(cands)
	info_gain = 0

	for i in results:
		info_gain += (results[i] / cand_count) * log(cand_count / results[i], 2)
	return info_gain


def best_guess(cands, allowed_guesses):
	best_val = -1
	best_g = ""

	debug_counter = 0
	debug_cand_count = len(allowed_guesses)
	for i in allowed_guesses:
		e = entropy(i, cands)
		print(floor(debug_counter * 100 / debug_cand_count))
		debug_counter += 1
		if e > best_val:
			best_val = e
			best_g = i
	return [best_val, best_g]

# Game loop
remaining = set(candidates)
turn = 0
while True:
	if game_type == "PRIMES" and digit_count == 5 and turn == 0:
		best = [6.82612526267251, "12653"]
	else:
		best = best_guess(remaining, candidates)
	print("Candidates Left:", len(remaining))
	print(remaining)
	print("Recommended guess: " + best[1])
	print("Rating:", best[0].n())
	guess = input("Enter guess: ")
	result = input("Result: ")

	temp = set()
	for i in remaining:
		if get_result(guess, i) == result:
			temp.add(i)
	remaining = temp

	if len(remaining) == 1:
		print("Answer:", list(remaining)[0])
		break
	turn += 1

print("In", time.time() - start, "seconds")