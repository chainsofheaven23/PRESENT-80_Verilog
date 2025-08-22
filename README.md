# PRESENT-80 Encryption in Verilog

This is a simple Verilog project that implements the **PRESENT-80** encryption algorithm. It's a type of "lightweight" encryption, meaning it's designed to run on small devices like IoT sensors or RFID tags.

  - **What it does**: Takes a 64-bit block of data and an 80-bit key to produce a 64-bit encrypted block.
  - **Hardware-Ready**: The code is written to be easily converted into a real hardware chip (on an FPGA or ASIC).
  - **Tested**: It includes a test program that automatically checks if the code is working correctly using official examples.

-----

## How It Works

The design is small and efficient. It takes the input data and key and puts them through a "round" of processing. This round scrambles and mixes the data. It repeats this process **31 times** to make the encryption strong. A small controller (an FSM) keeps track of the rounds.

```
                  +----------------+
      80-bit Key ->|  Key Schedule  |--> Round Key
                  +----------------+
                         |
                         v
                  +----------------+
    64-bit Data ->| Mix with Key   |<----+
                  +----------------+     |
                         |               |
                         v               | 31 Rounds
                  +----------------+     |
                  | Scramble Bits  |     |
                  +----------------+     |
                         |               |
                         v               |
                  +----------------+     |
                  | Permute Bits   |-----+
                  +----------------+
                         |
                         v
                  Encrypted Data
```

-----


### ➡️ I/O Ports (Inputs & Outputs)

Here are the connections for the main Verilog module.

| Port | Direction | Size | Description |
| :--- | :---: | :---: | :--- |
| `clk` | **Input** | 1-bit | Your main system **clock**. |
| `rst` | **Input** | 1-bit | The **reset** signal (active-high). |
| `enable` | **Input** | 1-bit | Keep this high to **start** and run the encryption. |
| `plaintext` | **Input** | 64-bit | The 64-bit **data** you want to encrypt. |
| `key_in` | **Input** | 80-bit | The 80-bit secret **key**. |
| `ciphertext` | **Output** | 64-bit | The final 64-bit **encrypted data**. |
| `done` | **Output** | 1-bit | A signal that goes high

-----

## How to Test It

You'll need a Verilog simulator to run the test. These instructions are for the free simulator **Icarus Verilog**.

1.  **Clone the code** from GitHub.
2.  **Compile the Verilog files**. Open your terminal in the project folder and run this command. This assumes your code is in an `rtl` folder and the test file is in a `tb` folder.
    ```sh
    iverilog -o sim_output tb/tb_present_80.v rtl/*.v
    ```
3.  **Run the compiled simulation**.
    ```sh
    vvp sim_output
    ```
    The program will tell you if the tests passed or failed\!

-----

## Notes

  - **Synthesis**: You can run this code through a tool like Xilinx Vivado to see how much space it would take on an FPGA and how fast it could run.
  - **Acknowledgments**: This code is based on the original PRESENT cipher designed by Bogdanov et al. You can find the original paper online for more details.
  - **Contributing**: Feel free to make improvements and submit a pull request\!
