Lean        SciLean adapter? raw lean?
Python      Mainly scipy's signal module.
GNU Octave  Debian stable (currently 9.4).

Runnable bpsk in a jupyter notebook at
~/.trash/siglib/building-blocks/host

https://www.mathworks.com/help/comm/ref/pskmod.html#bvaednr-1
Modulation order 4
data = randi([0 4-1],10,1)
     3
     4
    -4
     5
     1
    -4
    -2
     1
     5
     5


theorem Example_3_2_4
    (P Q R : Prop) (h : P → (Q → R)) : ¬R → (P → ¬Q) := by
  assume h2 : ¬R
  assume h3 : P
  have h4 : Q → R := h h3
  contrapos at h4            --Now h4 : ¬R → ¬Q
  show ¬Q from h4 h2
  done


## Never worked with Lean before?
> Please open an [issue] if you find this section not as excellent as it can be!

The Lean website lists official learning materials in several books. Alternatively these questions can be
your Lean tutor.

How do I eval anyway a dependently-typed function even though I don't have the proof that it requires yet?
Example prop that cannot be proved by decide?
How do I insert IO print statements inside getElement?
What is absurd and can I implement what it does by hand?
How do I extract getElement to another .lean file?

Finally, `import Consig.Data`. How can I invoke ... and ... while arguing that my BPSK ...


    "# --- 1. Parameters ---\n",
    "N = 10_000                         # number of bits\n",
    "Fs = 1000                         # sampling rate (Hz)\n",
    "samples_per_symbol = 8\n",
    "Rs = Fs // samples_per_symbol     # symbol rate\n",
    "EbN0_dB = 6                       # SNR in dB\n",
    "\n",
    "# --- 2. Transmitter ---\n",
    "bits = np.random.randint(0, 2, N)\n",
    "symbols = 2 * bits - 1  # BPSK: 0 ╬ô├Ñ├å -1, 1 ╬ô├Ñ├å +1\n",
    "\n",
    "# Upsample\n",
    "tx_upsampled = np.zeros(N * samples_per_symbol)\n",
    "tx_upsampled[::samples_per_symbol] = symbols\n",
    "\n",
    "# Pulse shaping filter (e.g., simple rectangular or raised cosine)\n",
    "h = signal.firwin(numtaps=101, cutoff=1/samples_per_symbol, window=\"hamming\")\n",
    "tx_filtered = signal.lfilter(h, 1.0, tx_upsampled)\n",
    "\n",
    "# --- 3. Channel (AWGN) ---\n",
    "# Normalize power\n",
    "signal_power = np.mean(tx_filtered**2)\n",
    "Eb = signal_power / Rs\n",
    "N0 = Eb / (10**(EbN0_dB/10))\n",
    "noise = np.sqrt(N0 * Fs / 2) * np.random.randn(len(tx_filtered))\n",
    "\n",
    "rx_signal = tx_filtered + noise\n",
    "\n",
    "# --- 4. Receiver ---\n",
    "# Matched filter (same as transmit filter)\n",
    "rx_filtered = signal.lfilter(h, 1.0, rx_signal)\n",
    "\n",
    "# Symbol sampling (accounting for filter delay)\n",
    "delay = (len(h) - 1) // 2\n",
    "sample_points = np.arange(delay + samples_per_symbol//2, len(rx_filtered), samples_per_symbol)\n",
    "rx_samples = rx_filtered[sample_points]\n",
    "\n",
    "# Decision\n",
    "rx_bits = (rx_samples > 0).astype(int)\n",
    "\n",
    "# --- 5. BER Calculation ---\n",
    "bits_aligned = bits[:len(rx_bits)]\n",
    "# bit_errors = np.sum(bits != rx_bits)\n",
    "bit_errors = np.sum(bits_aligned != rx_bits)\n",
    "ber = bit_errors / N\n",
    "print(f\"BER @ {EbN0_dB} dB Eb/N0: {ber:.5f}\")\n",
    "\n",
    "# --- 6. Visualization ---\n",
    "plt.figure(figsize=(12, 6))\n",
    "\n",
    "plt.subplot(2, 1, 1)\n",
    "plt.title(\"BPSK Signal (Tx + Noise)\")\n",
    "plt.plot(tx_filtered[:500], label=\"Tx Signal\")\n",
    "plt.plot(rx_signal[:500], label=\"Rx Signal (with noise)\", alpha=0.6)\n",
    "plt.legend()\n",
    "plt.grid(True)\n",
    "\n",
    "plt.subplot(2, 1, 2)\n",
    "\n",
    "plt.title(\"Eye Diagram\")\n",
    "eye_data = rx_filtered[delay:]\n",
    "eye_len = (len(eye_data) // samples_per_symbol) * samples_per_symbol\n",
    "eye = eye_data[:eye_len].reshape(-1, samples_per_symbol)\n",
    "# eye = rx_filtered[delay:].reshape(-1, samples_per_symbol)\n",
    "for i in range(min(100, eye.shape[0])):\n",
    "    plt.plot(eye[i], color='blue', alpha=0.2)\n",
    "plt.grid(True)\n",
    "\n",
    "plt.tight_layout()\n",
    "# plt.show()\n",
    "plt.savefig(\"bpsk_simulation.png\", dpi=300)\n"

