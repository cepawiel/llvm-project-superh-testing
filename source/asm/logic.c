int and_rr(int a, int b) {
	return a & b;
}

int and_ri(int a) {
	return a & 0x5;
}

int or_rr(int a, int b) {
	return a | b;
}

int or_ri(int a) {
	return a | 0x5;
}

int compare_eq_rr(int a, int b) {
	return (a == b);
}

int compare_eq_ri(int a) {
	return (a == 0);
}

int compare_gt_rr(int a, int b) {
	return (a > b);
}

int compare_gt_ri(int a) {
	return (a > 0);
}

int compare_lt_rr(int a, int b) {
	return (a < b);
}

int compare_lt_ri(int a) {
	return (a < 0);
}

int compare_gte_rr(int a, int b) {
	return (a >= b);
}

int compare_gte_ri(int a) {
	return (a >= 0);
}

int compare_lte_rr(int a, int b) {
	return (a <= b);
}

int compare_lte_ri(int a) {
	return (a <= 0);
}

// int compare_neq_rr(int a, int b) {
// 	return (a != b);
// }

int compare_neq_ri(int a) {
	return (a != 0);
}