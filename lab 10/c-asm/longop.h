extern "C" {
	void addLongop(unsigned int* C, unsigned int* B, unsigned int* A, int length);
	void subLongop(unsigned int* C, unsigned int* B, unsigned int* A, int length);
	void mulN_x_N(unsigned int* C, unsigned int* B, unsigned int* A, int length);
}
