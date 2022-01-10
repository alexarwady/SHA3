Installation Guide
These are the steps in order to run the project on ModelSim:
• Download ModelSim from their official website.
• Download the files from https://github.com/alexarwady/SHA3 and include them in the project directory.
• Place the test vectors in the file test_vectors.txt. Note that some test vectors are already present. Each test case is made of an id, a plaintext and a ciphertext separated by new lines.
• Compile all files.
• Simulate the sha3_tb test bench file.
• Every test case takes 2296900 ns to give a correct output. Note that the simulation starts with an additional 200 ns for the reset signal.
• If the output is incorrect, it should give a note in the logs. Otherwise, it gives the test id with a note saying that the ciphertext is correct. The output can be checked by comparing the signals ct_int and ct_int_true
