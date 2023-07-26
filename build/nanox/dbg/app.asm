
build/nanox/bin/app.elf:     file format elf32-littlearm


Disassembly of section .text:

c0de0000 <main>:
    libcall_params[2] = RUN_APPLICATION;
    os_lib_call((unsigned int *) &libcall_params);
}

// Weird low-level black magic. No need to edit this.
__attribute__((section(".boot"))) int main(int arg0) {
c0de0000:	b570      	push	{r4, r5, r6, lr}
c0de0002:	b08c      	sub	sp, #48	; 0x30
c0de0004:	4604      	mov	r4, r0
    // Exit critical section
    __asm volatile("cpsie i");
c0de0006:	b662      	cpsie	i

    // Ensure exception will work as planned
    os_boot();
c0de0008:	f000 fd26 	bl	c0de0a58 <os_boot>
c0de000c:	466d      	mov	r5, sp

    // Try catch block. Please read the docs for more information on how to use those!
    BEGIN_TRY {
        TRY {
c0de000e:	4628      	mov	r0, r5
c0de0010:	f001 fa5c 	bl	c0de14cc <setjmp>
c0de0014:	85a8      	strh	r0, [r5, #44]	; 0x2c
c0de0016:	b285      	uxth	r5, r0
c0de0018:	4668      	mov	r0, sp
c0de001a:	2d00      	cmp	r5, #0
c0de001c:	d10d      	bne.n	c0de003a <main+0x3a>
c0de001e:	f000 ff33 	bl	c0de0e88 <try_context_set>
c0de0022:	900a      	str	r0, [sp, #40]	; 0x28
// get API level
SYSCALL unsigned int get_api_level(void);

#ifndef HAVE_BOLOS
static inline void check_api_level(unsigned int apiLevel) {
  if (apiLevel < get_api_level()) {
c0de0024:	f000 fef5 	bl	c0de0e12 <get_api_level>
c0de0028:	280d      	cmp	r0, #13
c0de002a:	d21e      	bcs.n	c0de006a <main+0x6a>
            // Low-level black magic.
            check_api_level(CX_COMPAT_APILEVEL);

            // Check if we are called from the dashboard.
            if (!arg0) {
c0de002c:	2c00      	cmp	r4, #0
c0de002e:	d11f      	bne.n	c0de0070 <main+0x70>
                // Called from dashboard, launch Ethereum app
                call_app_ethereum();
c0de0030:	f000 fd04 	bl	c0de0a3c <call_app_ethereum>
c0de0034:	2000      	movs	r0, #0
    }
    END_TRY;

    // Will not get reached.
    return 0;
}
c0de0036:	b00c      	add	sp, #48	; 0x30
c0de0038:	bd70      	pop	{r4, r5, r6, pc}
c0de003a:	2600      	movs	r6, #0
        CATCH_OTHER(e) {
c0de003c:	8586      	strh	r6, [r0, #44]	; 0x2c
c0de003e:	980a      	ldr	r0, [sp, #40]	; 0x28
c0de0040:	f000 ff22 	bl	c0de0e88 <try_context_set>
c0de0044:	4814      	ldr	r0, [pc, #80]	; (c0de0098 <main+0x98>)
            switch (e) {
c0de0046:	4285      	cmp	r5, r0
c0de0048:	d001      	beq.n	c0de004e <main+0x4e>
c0de004a:	2d07      	cmp	r5, #7
c0de004c:	d107      	bne.n	c0de005e <main+0x5e>
c0de004e:	2083      	movs	r0, #131	; 0x83
c0de0050:	0040      	lsls	r0, r0, #1
    switch (args[0]) {
c0de0052:	6821      	ldr	r1, [r4, #0]
c0de0054:	4281      	cmp	r1, r0
c0de0056:	d102      	bne.n	c0de005e <main+0x5e>
            ((ethQueryContractUI_t *) args[1])->result = ETH_PLUGIN_RESULT_ERROR;
c0de0058:	6860      	ldr	r0, [r4, #4]
c0de005a:	2134      	movs	r1, #52	; 0x34
c0de005c:	5446      	strb	r6, [r0, r1]
            PRINTF("Exception 0x%x caught\n", e);
c0de005e:	480f      	ldr	r0, [pc, #60]	; (c0de009c <main+0x9c>)
c0de0060:	4478      	add	r0, pc
c0de0062:	4629      	mov	r1, r5
c0de0064:	f000 fd1e 	bl	c0de0aa4 <mcu_usb_printf>
c0de0068:	e00b      	b.n	c0de0082 <main+0x82>
c0de006a:	20ff      	movs	r0, #255	; 0xff
    os_sched_exit(-1);
c0de006c:	f000 feee 	bl	c0de0e4c <os_sched_exit>
                if (args[0] != ETH_PLUGIN_CHECK_PRESENCE) {
c0de0070:	6820      	ldr	r0, [r4, #0]
c0de0072:	2183      	movs	r1, #131	; 0x83
c0de0074:	0049      	lsls	r1, r1, #1
c0de0076:	31f9      	adds	r1, #249	; 0xf9
c0de0078:	4288      	cmp	r0, r1
c0de007a:	d002      	beq.n	c0de0082 <main+0x82>
                    dispatch_plugin_calls(args[0], (void *) args[1]);
c0de007c:	6861      	ldr	r1, [r4, #4]
c0de007e:	f000 fca3 	bl	c0de09c8 <dispatch_plugin_calls>
        FINALLY {
c0de0082:	f000 fef9 	bl	c0de0e78 <try_context_get>
c0de0086:	4669      	mov	r1, sp
c0de0088:	4288      	cmp	r0, r1
c0de008a:	d102      	bne.n	c0de0092 <main+0x92>
c0de008c:	980a      	ldr	r0, [sp, #40]	; 0x28
c0de008e:	f000 fefb 	bl	c0de0e88 <try_context_set>
            os_lib_end();
c0de0092:	f000 fed3 	bl	c0de0e3c <os_lib_end>
c0de0096:	46c0      	nop			; (mov r8, r8)
c0de0098:	00006502 	.word	0x00006502
c0de009c:	000017aa 	.word	0x000017aa

c0de00a0 <cx_hash_get_size>:
CX_TRAMPOLINE _NR_cx_edwards_compress_point_no_throw       cx_edwards_compress_point_no_throw
CX_TRAMPOLINE _NR_cx_edwards_decompress_point_no_throw     cx_edwards_decompress_point_no_throw
CX_TRAMPOLINE _NR_cx_encode_coord                          cx_encode_coord
CX_TRAMPOLINE _NR_cx_hash_final                            cx_hash_final
CX_TRAMPOLINE _NR_cx_hash_get_info                         cx_hash_get_info
CX_TRAMPOLINE _NR_cx_hash_get_size                         cx_hash_get_size
c0de00a0:	b403      	push	{r0, r1}
c0de00a2:	4801      	ldr	r0, [pc, #4]	; (c0de00a8 <cx_hash_get_size+0x8>)
c0de00a4:	e011      	b.n	c0de00ca <cx_trampoline_helper>
c0de00a6:	0000      	.short	0x0000
c0de00a8:	00000045 	.word	0x00000045

c0de00ac <cx_hash_no_throw>:
CX_TRAMPOLINE _NR_cx_hash_init                             cx_hash_init
CX_TRAMPOLINE _NR_cx_hash_init_ex                          cx_hash_init_ex
CX_TRAMPOLINE _NR_cx_hash_no_throw                         cx_hash_no_throw
c0de00ac:	b403      	push	{r0, r1}
c0de00ae:	4801      	ldr	r0, [pc, #4]	; (c0de00b4 <cx_hash_no_throw+0x8>)
c0de00b0:	e00b      	b.n	c0de00ca <cx_trampoline_helper>
c0de00b2:	0000      	.short	0x0000
c0de00b4:	00000048 	.word	0x00000048

c0de00b8 <cx_keccak_init_no_throw>:
CX_TRAMPOLINE _NR_cx_hmac_sha256_init_no_throw             cx_hmac_sha256_init_no_throw
CX_TRAMPOLINE _NR_cx_hmac_sha384_init                      cx_hmac_sha384_init
CX_TRAMPOLINE _NR_cx_hmac_sha512                           cx_hmac_sha512
CX_TRAMPOLINE _NR_cx_hmac_sha512_init_no_throw             cx_hmac_sha512_init_no_throw
CX_TRAMPOLINE _NR_cx_hmac_update                           cx_hmac_update
CX_TRAMPOLINE _NR_cx_keccak_init_no_throw                  cx_keccak_init_no_throw
c0de00b8:	b403      	push	{r0, r1}
c0de00ba:	4801      	ldr	r0, [pc, #4]	; (c0de00c0 <cx_keccak_init_no_throw+0x8>)
c0de00bc:	e005      	b.n	c0de00ca <cx_trampoline_helper>
c0de00be:	0000      	.short	0x0000
c0de00c0:	0000005a 	.word	0x0000005a

c0de00c4 <cx_x448>:
CX_TRAMPOLINE _NR_cx_swap_buffer32                         cx_swap_buffer32
CX_TRAMPOLINE _NR_cx_swap_buffer64                         cx_swap_buffer64
CX_TRAMPOLINE _NR_cx_swap_uint32                           cx_swap_uint32
CX_TRAMPOLINE _NR_cx_swap_uint64                           cx_swap_uint64
CX_TRAMPOLINE _NR_cx_x25519                                cx_x25519
CX_TRAMPOLINE _NR_cx_x448                                  cx_x448
c0de00c4:	b403      	push	{r0, r1}
c0de00c6:	4802      	ldr	r0, [pc, #8]	; (c0de00d0 <cx_trampoline_helper+0x6>)
c0de00c8:	e7ff      	b.n	c0de00ca <cx_trampoline_helper>

c0de00ca <cx_trampoline_helper>:

.thumb_func
cx_trampoline_helper:
  ldr  r1, =CX_TRAMPOLINE_ADDR // _cx_trampoline address
c0de00ca:	4902      	ldr	r1, [pc, #8]	; (c0de00d4 <cx_trampoline_helper+0xa>)
  bx   r1
c0de00cc:	4708      	bx	r1
c0de00ce:	0000      	.short	0x0000
CX_TRAMPOLINE _NR_cx_x448                                  cx_x448
c0de00d0:	00000087 	.word	0x00000087
  ldr  r1, =CX_TRAMPOLINE_ADDR // _cx_trampoline address
c0de00d4:	00210001 	.word	0x00210001

c0de00d8 <getEthAddressStringFromBinary>:
#include "eth_internals.h"

void getEthAddressStringFromBinary(uint8_t *address,
                                   char *out,
                                   cx_sha3_t *sha3Context,
                                   uint64_t chainId) {
c0de00d8:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de00da:	b091      	sub	sp, #68	; 0x44
c0de00dc:	9202      	str	r2, [sp, #8]
c0de00de:	9103      	str	r1, [sp, #12]
c0de00e0:	4605      	mov	r5, r0
c0de00e2:	2601      	movs	r6, #1
c0de00e4:	9816      	ldr	r0, [sp, #88]	; 0x58
    } locals_union;

    uint8_t i;
    bool eip1191 = false;
    uint32_t offset = 0;
    switch (chainId) {
c0de00e6:	4601      	mov	r1, r0
c0de00e8:	43b1      	bics	r1, r6
c0de00ea:	221e      	movs	r2, #30
c0de00ec:	404a      	eors	r2, r1
c0de00ee:	9917      	ldr	r1, [sp, #92]	; 0x5c
c0de00f0:	430a      	orrs	r2, r1
c0de00f2:	2400      	movs	r4, #0
        case 30:
        case 31:
            eip1191 = true;
            break;
    }
    if (eip1191) {
c0de00f4:	2a00      	cmp	r2, #0
c0de00f6:	4622      	mov	r2, r4
c0de00f8:	d116      	bne.n	c0de0128 <getEthAddressStringFromBinary+0x50>
c0de00fa:	aa04      	add	r2, sp, #16
c0de00fc:	9201      	str	r2, [sp, #4]
c0de00fe:	2733      	movs	r7, #51	; 0x33
        u64_to_string(chainId, (char *) locals_union.tmp, sizeof(locals_union.tmp));
c0de0100:	463b      	mov	r3, r7
c0de0102:	f000 f857 	bl	c0de01b4 <u64_to_string>
        offset = strnlen((char *) locals_union.tmp, sizeof(locals_union.tmp));
c0de0106:	9801      	ldr	r0, [sp, #4]
c0de0108:	4639      	mov	r1, r7
c0de010a:	f001 fa87 	bl	c0de161c <strnlen>
        strlcat((char *) locals_union.tmp + offset, "0x", sizeof(locals_union.tmp) - offset);
c0de010e:	9901      	ldr	r1, [sp, #4]
c0de0110:	180b      	adds	r3, r1, r0
c0de0112:	1a3a      	subs	r2, r7, r0
c0de0114:	4925      	ldr	r1, [pc, #148]	; (c0de01ac <getEthAddressStringFromBinary+0xd4>)
c0de0116:	4479      	add	r1, pc
c0de0118:	4618      	mov	r0, r3
c0de011a:	f001 f9f1 	bl	c0de1500 <strlcat>
        offset = strnlen((char *) locals_union.tmp, sizeof(locals_union.tmp));
c0de011e:	9801      	ldr	r0, [sp, #4]
c0de0120:	4639      	mov	r1, r7
c0de0122:	f001 fa7b 	bl	c0de161c <strnlen>
c0de0126:	4602      	mov	r2, r0
c0de0128:	a804      	add	r0, sp, #16
c0de012a:	9201      	str	r2, [sp, #4]
    }
    for (i = 0; i < 20; i++) {
c0de012c:	1880      	adds	r0, r0, r2
c0de012e:	4f20      	ldr	r7, [pc, #128]	; (c0de01b0 <getEthAddressStringFromBinary+0xd8>)
c0de0130:	447f      	add	r7, pc
c0de0132:	2c14      	cmp	r4, #20
c0de0134:	d00a      	beq.n	c0de014c <getEthAddressStringFromBinary+0x74>
        uint8_t digit = address[i];
c0de0136:	5d29      	ldrb	r1, [r5, r4]
c0de0138:	220f      	movs	r2, #15
        locals_union.tmp[offset + 2 * i] = HEXDIGITS[(digit >> 4) & 0x0f];
        locals_union.tmp[offset + 2 * i + 1] = HEXDIGITS[digit & 0x0f];
c0de013a:	400a      	ands	r2, r1
c0de013c:	5cba      	ldrb	r2, [r7, r2]
c0de013e:	7042      	strb	r2, [r0, #1]
        locals_union.tmp[offset + 2 * i] = HEXDIGITS[(digit >> 4) & 0x0f];
c0de0140:	0909      	lsrs	r1, r1, #4
c0de0142:	5c79      	ldrb	r1, [r7, r1]
c0de0144:	7001      	strb	r1, [r0, #0]
    for (i = 0; i < 20; i++) {
c0de0146:	1c80      	adds	r0, r0, #2
c0de0148:	1c64      	adds	r4, r4, #1
c0de014a:	e7f2      	b.n	c0de0132 <getEthAddressStringFromBinary+0x5a>
c0de014c:	9c02      	ldr	r4, [sp, #8]
    }
    cx_keccak_init(sha3Context, 256);
c0de014e:	4620      	mov	r0, r4
c0de0150:	f000 f86c 	bl	c0de022c <cx_keccak_init>
c0de0154:	9a01      	ldr	r2, [sp, #4]
    cx_hash((cx_hash_t *) sha3Context,
            CX_LAST,
            locals_union.tmp,
            offset + 40,
c0de0156:	3228      	adds	r2, #40	; 0x28
c0de0158:	a904      	add	r1, sp, #16
    cx_hash((cx_hash_t *) sha3Context,
c0de015a:	4620      	mov	r0, r4
c0de015c:	460b      	mov	r3, r1
c0de015e:	f000 f86f 	bl	c0de0240 <cx_hash>
c0de0162:	2000      	movs	r0, #0
            locals_union.hashChecksum,
            32);
    for (i = 0; i < 40; i++) {
c0de0164:	2828      	cmp	r0, #40	; 0x28
c0de0166:	d01b      	beq.n	c0de01a0 <getEthAddressStringFromBinary+0xc8>
        uint8_t digit = address[i / 2];
        if ((i % 2) == 0) {
c0de0168:	4602      	mov	r2, r0
c0de016a:	4032      	ands	r2, r6
        uint8_t digit = address[i / 2];
c0de016c:	0843      	lsrs	r3, r0, #1
c0de016e:	5ce9      	ldrb	r1, [r5, r3]
        if ((i % 2) == 0) {
c0de0170:	2a00      	cmp	r2, #0
c0de0172:	d002      	beq.n	c0de017a <getEthAddressStringFromBinary+0xa2>
c0de0174:	240f      	movs	r4, #15
c0de0176:	4021      	ands	r1, r4
c0de0178:	e000      	b.n	c0de017c <getEthAddressStringFromBinary+0xa4>
c0de017a:	0909      	lsrs	r1, r1, #4
            digit = (digit >> 4) & 0x0f;
        } else {
            digit = digit & 0x0f;
        }
        if (digit < 10) {
c0de017c:	2909      	cmp	r1, #9
c0de017e:	d801      	bhi.n	c0de0184 <getEthAddressStringFromBinary+0xac>
            out[i] = HEXDIGITS[digit];
c0de0180:	5c79      	ldrb	r1, [r7, r1]
c0de0182:	e009      	b.n	c0de0198 <getEthAddressStringFromBinary+0xc0>
c0de0184:	ac04      	add	r4, sp, #16
        } else {
            int v = (locals_union.hashChecksum[i / 2] >> (4 * (1 - i % 2))) & 0x0f;
c0de0186:	5ce3      	ldrb	r3, [r4, r3]
c0de0188:	0092      	lsls	r2, r2, #2
c0de018a:	2404      	movs	r4, #4
c0de018c:	4054      	eors	r4, r2
            if (v >= 8) {
c0de018e:	40e3      	lsrs	r3, r4
c0de0190:	071a      	lsls	r2, r3, #28
c0de0192:	5c79      	ldrb	r1, [r7, r1]
c0de0194:	d500      	bpl.n	c0de0198 <getEthAddressStringFromBinary+0xc0>
c0de0196:	3920      	subs	r1, #32
c0de0198:	9a03      	ldr	r2, [sp, #12]
c0de019a:	5411      	strb	r1, [r2, r0]
    for (i = 0; i < 40; i++) {
c0de019c:	1c40      	adds	r0, r0, #1
c0de019e:	e7e1      	b.n	c0de0164 <getEthAddressStringFromBinary+0x8c>
c0de01a0:	2028      	movs	r0, #40	; 0x28
c0de01a2:	2100      	movs	r1, #0
            } else {
                out[i] = HEXDIGITS[digit];
            }
        }
    }
    out[40] = '\0';
c0de01a4:	9a03      	ldr	r2, [sp, #12]
c0de01a6:	5411      	strb	r1, [r2, r0]
}
c0de01a8:	b011      	add	sp, #68	; 0x44
c0de01aa:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0de01ac:	00001753 	.word	0x00001753
c0de01b0:	00001708 	.word	0x00001708

c0de01b4 <u64_to_string>:
    }

    out_buffer[out_buffer_size - 1] = '\0';
}

void u64_to_string(uint64_t src, char *dst, uint8_t dst_size) {
c0de01b4:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de01b6:	b087      	sub	sp, #28
c0de01b8:	9302      	str	r3, [sp, #8]
c0de01ba:	460b      	mov	r3, r1
c0de01bc:	4605      	mov	r5, r0
c0de01be:	2400      	movs	r4, #0
c0de01c0:	9201      	str	r2, [sp, #4]
    // Copy the numbers in ASCII format.
    uint8_t i = 0;
    do {
        // Checking `i + 1` to make sure we have enough space for '\0'.
        if (i + 1 >= dst_size) {
c0de01c2:	b2e7      	uxtb	r7, r4
c0de01c4:	1c78      	adds	r0, r7, #1
c0de01c6:	9902      	ldr	r1, [sp, #8]
c0de01c8:	4288      	cmp	r0, r1
c0de01ca:	d229      	bcs.n	c0de0220 <u64_to_string+0x6c>
c0de01cc:	220a      	movs	r2, #10
c0de01ce:	9203      	str	r2, [sp, #12]
c0de01d0:	2600      	movs	r6, #0
            THROW(0x6502);
        }
        dst[i] = src % 10 + '0';
        src /= 10;
c0de01d2:	4628      	mov	r0, r5
c0de01d4:	4619      	mov	r1, r3
c0de01d6:	9306      	str	r3, [sp, #24]
c0de01d8:	4633      	mov	r3, r6
c0de01da:	f000 feed 	bl	c0de0fb8 <__aeabi_uldivmod>
c0de01de:	9005      	str	r0, [sp, #20]
c0de01e0:	9104      	str	r1, [sp, #16]
c0de01e2:	9a03      	ldr	r2, [sp, #12]
c0de01e4:	4633      	mov	r3, r6
c0de01e6:	f000 ff07 	bl	c0de0ff8 <__aeabi_lmul>
c0de01ea:	1a28      	subs	r0, r5, r0
c0de01ec:	2130      	movs	r1, #48	; 0x30
        dst[i] = src % 10 + '0';
c0de01ee:	4301      	orrs	r1, r0
c0de01f0:	9a01      	ldr	r2, [sp, #4]
c0de01f2:	55d1      	strb	r1, [r2, r7]
        i++;
c0de01f4:	1c64      	adds	r4, r4, #1
c0de01f6:	2009      	movs	r0, #9
    } while (src);
c0de01f8:	1b40      	subs	r0, r0, r5
c0de01fa:	4630      	mov	r0, r6
c0de01fc:	9906      	ldr	r1, [sp, #24]
c0de01fe:	4188      	sbcs	r0, r1
c0de0200:	9d05      	ldr	r5, [sp, #20]
c0de0202:	9b04      	ldr	r3, [sp, #16]
c0de0204:	d3dd      	bcc.n	c0de01c2 <u64_to_string+0xe>

    // Null terminate string
    dst[i] = '\0';
c0de0206:	b2e0      	uxtb	r0, r4
c0de0208:	5416      	strb	r6, [r2, r0]

    // Revert the string
    i--;
    uint8_t j = 0;
    while (j < i) {
c0de020a:	42be      	cmp	r6, r7
c0de020c:	d206      	bcs.n	c0de021c <u64_to_string+0x68>
        char tmp = dst[i];
c0de020e:	5dd0      	ldrb	r0, [r2, r7]
        dst[i] = dst[j];
c0de0210:	5d91      	ldrb	r1, [r2, r6]
c0de0212:	55d1      	strb	r1, [r2, r7]
        dst[j] = tmp;
c0de0214:	5590      	strb	r0, [r2, r6]
        i--;
c0de0216:	1e7f      	subs	r7, r7, #1
        j++;
c0de0218:	1c76      	adds	r6, r6, #1
c0de021a:	e7f6      	b.n	c0de020a <u64_to_string+0x56>
    }
}
c0de021c:	b007      	add	sp, #28
c0de021e:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0de0220:	4801      	ldr	r0, [pc, #4]	; (c0de0228 <u64_to_string+0x74>)
            THROW(0x6502);
c0de0222:	f000 fc1f 	bl	c0de0a64 <os_longjmp>
c0de0226:	46c0      	nop			; (mov r8, r8)
c0de0228:	00006502 	.word	0x00006502

c0de022c <cx_keccak_init>:
/**
 * @deprecated
 * See #cx_keccak_init_no_throw
 */
DEPRECATED static inline int cx_keccak_init ( cx_sha3_t * hash, size_t size )
{
c0de022c:	b580      	push	{r7, lr}
c0de022e:	2101      	movs	r1, #1
c0de0230:	0209      	lsls	r1, r1, #8
  CX_THROW(cx_keccak_init_no_throw(hash, size));
c0de0232:	f7ff ff41 	bl	c0de00b8 <cx_keccak_init_no_throw>
c0de0236:	2800      	cmp	r0, #0
c0de0238:	d100      	bne.n	c0de023c <cx_keccak_init+0x10>
  return CX_KECCAK;
c0de023a:	bd80      	pop	{r7, pc}
  CX_THROW(cx_keccak_init_no_throw(hash, size));
c0de023c:	f000 fc12 	bl	c0de0a64 <os_longjmp>

c0de0240 <cx_hash>:
/**
 * @deprecated
 * See #cx_hash_no_throw
 */
DEPRECATED static inline size_t cx_hash ( cx_hash_t * hash, uint32_t mode, const unsigned char * in, unsigned int len, unsigned char * out, unsigned int out_len )
{
c0de0240:	b5bc      	push	{r2, r3, r4, r5, r7, lr}
c0de0242:	4615      	mov	r5, r2
c0de0244:	460a      	mov	r2, r1
c0de0246:	4604      	mov	r4, r0
c0de0248:	2020      	movs	r0, #32
  CX_THROW(cx_hash_no_throw(hash, mode, in, len, out, out_len));
c0de024a:	9300      	str	r3, [sp, #0]
c0de024c:	9001      	str	r0, [sp, #4]
c0de024e:	2101      	movs	r1, #1
c0de0250:	4620      	mov	r0, r4
c0de0252:	462b      	mov	r3, r5
c0de0254:	f7ff ff2a 	bl	c0de00ac <cx_hash_no_throw>
c0de0258:	2800      	cmp	r0, #0
c0de025a:	d103      	bne.n	c0de0264 <cx_hash+0x24>
  return cx_hash_get_size(hash);
c0de025c:	4620      	mov	r0, r4
c0de025e:	f7ff ff1f 	bl	c0de00a0 <cx_hash_get_size>
c0de0262:	bdbc      	pop	{r2, r3, r4, r5, r7, pc}
  CX_THROW(cx_hash_no_throw(hash, mode, in, len, out, out_len));
c0de0264:	f000 fbfe 	bl	c0de0a64 <os_longjmp>

c0de0268 <adjustDecimals>:
                    uint8_t decimals) {
c0de0268:	b5f8      	push	{r3, r4, r5, r6, r7, lr}
    if ((srcLength == 1) && (*src == '0')) {
c0de026a:	2901      	cmp	r1, #1
c0de026c:	d10a      	bne.n	c0de0284 <adjustDecimals+0x1c>
c0de026e:	7804      	ldrb	r4, [r0, #0]
c0de0270:	2c30      	cmp	r4, #48	; 0x30
c0de0272:	d107      	bne.n	c0de0284 <adjustDecimals+0x1c>
        if (targetLength < 2) {
c0de0274:	2b02      	cmp	r3, #2
c0de0276:	d31a      	bcc.n	c0de02ae <adjustDecimals+0x46>
c0de0278:	2000      	movs	r0, #0
        target[1] = '\0';
c0de027a:	7050      	strb	r0, [r2, #1]
c0de027c:	2030      	movs	r0, #48	; 0x30
        target[0] = '0';
c0de027e:	7010      	strb	r0, [r2, #0]
c0de0280:	2001      	movs	r0, #1
}
c0de0282:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
c0de0284:	9f06      	ldr	r7, [sp, #24]
    if (srcLength <= decimals) {
c0de0286:	428f      	cmp	r7, r1
c0de0288:	d20e      	bcs.n	c0de02a8 <adjustDecimals+0x40>
        if (targetLength < srcLength + 1 + 1) {
c0de028a:	1c8d      	adds	r5, r1, #2
c0de028c:	429d      	cmp	r5, r3
c0de028e:	d80e      	bhi.n	c0de02ae <adjustDecimals+0x46>
c0de0290:	1bcd      	subs	r5, r1, r7
c0de0292:	4613      	mov	r3, r2
c0de0294:	4606      	mov	r6, r0
c0de0296:	9700      	str	r7, [sp, #0]
        while (offset < delta) {
c0de0298:	42b9      	cmp	r1, r7
c0de029a:	d00a      	beq.n	c0de02b2 <adjustDecimals+0x4a>
            target[offset++] = src[sourceOffset++];
c0de029c:	7834      	ldrb	r4, [r6, #0]
c0de029e:	701c      	strb	r4, [r3, #0]
        while (offset < delta) {
c0de02a0:	1c5b      	adds	r3, r3, #1
c0de02a2:	1c76      	adds	r6, r6, #1
c0de02a4:	1c7f      	adds	r7, r7, #1
c0de02a6:	e7f7      	b.n	c0de0298 <adjustDecimals+0x30>
        if (targetLength < srcLength + 1 + 2 + delta) {
c0de02a8:	1cfd      	adds	r5, r7, #3
c0de02aa:	429d      	cmp	r5, r3
c0de02ac:	d912      	bls.n	c0de02d4 <adjustDecimals+0x6c>
c0de02ae:	2000      	movs	r0, #0
}
c0de02b0:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
        if (decimals != 0) {
c0de02b2:	9b00      	ldr	r3, [sp, #0]
c0de02b4:	2b00      	cmp	r3, #0
c0de02b6:	462b      	mov	r3, r5
c0de02b8:	d002      	beq.n	c0de02c0 <adjustDecimals+0x58>
c0de02ba:	232e      	movs	r3, #46	; 0x2e
            target[offset++] = '.';
c0de02bc:	5553      	strb	r3, [r2, r5]
c0de02be:	1c6b      	adds	r3, r5, #1
        while (sourceOffset < srcLength) {
c0de02c0:	1940      	adds	r0, r0, r5
c0de02c2:	18d6      	adds	r6, r2, r3
c0de02c4:	2400      	movs	r4, #0
c0de02c6:	192f      	adds	r7, r5, r4
c0de02c8:	428f      	cmp	r7, r1
c0de02ca:	d211      	bcs.n	c0de02f0 <adjustDecimals+0x88>
            target[offset++] = src[sourceOffset++];
c0de02cc:	5d07      	ldrb	r7, [r0, r4]
c0de02ce:	5537      	strb	r7, [r6, r4]
        while (sourceOffset < srcLength) {
c0de02d0:	1c64      	adds	r4, r4, #1
c0de02d2:	e7f8      	b.n	c0de02c6 <adjustDecimals+0x5e>
c0de02d4:	232e      	movs	r3, #46	; 0x2e
        target[offset++] = '.';
c0de02d6:	7053      	strb	r3, [r2, #1]
c0de02d8:	2530      	movs	r5, #48	; 0x30
        target[offset++] = '0';
c0de02da:	7015      	strb	r5, [r2, #0]
c0de02dc:	463c      	mov	r4, r7
        for (uint32_t i = 0; i < delta; i++) {
c0de02de:	1a7e      	subs	r6, r7, r1
c0de02e0:	1cb3      	adds	r3, r6, #2
c0de02e2:	1c97      	adds	r7, r2, #2
c0de02e4:	2e00      	cmp	r6, #0
c0de02e6:	d005      	beq.n	c0de02f4 <adjustDecimals+0x8c>
            target[offset++] = '0';
c0de02e8:	703d      	strb	r5, [r7, #0]
        for (uint32_t i = 0; i < delta; i++) {
c0de02ea:	1c7f      	adds	r7, r7, #1
c0de02ec:	1e76      	subs	r6, r6, #1
c0de02ee:	e7f9      	b.n	c0de02e4 <adjustDecimals+0x7c>
c0de02f0:	1918      	adds	r0, r3, r4
c0de02f2:	e00a      	b.n	c0de030a <adjustDecimals+0xa2>
        for (uint32_t i = 0; i < srcLength; i++) {
c0de02f4:	1915      	adds	r5, r2, r4
c0de02f6:	2602      	movs	r6, #2
c0de02f8:	1a71      	subs	r1, r6, r1
c0de02fa:	2902      	cmp	r1, #2
c0de02fc:	d004      	beq.n	c0de0308 <adjustDecimals+0xa0>
            target[offset++] = src[i];
c0de02fe:	7806      	ldrb	r6, [r0, #0]
c0de0300:	546e      	strb	r6, [r5, r1]
        for (uint32_t i = 0; i < srcLength; i++) {
c0de0302:	1c40      	adds	r0, r0, #1
c0de0304:	1c49      	adds	r1, r1, #1
c0de0306:	e7f8      	b.n	c0de02fa <adjustDecimals+0x92>
c0de0308:	1860      	adds	r0, r4, r1
c0de030a:	2100      	movs	r1, #0
c0de030c:	5411      	strb	r1, [r2, r0]
    for (uint32_t i = startOffset; i < offset; i++) {
c0de030e:	4283      	cmp	r3, r0
c0de0310:	d20a      	bcs.n	c0de0328 <adjustDecimals+0xc0>
        if (target[i] == '0') {
c0de0312:	2900      	cmp	r1, #0
c0de0314:	461c      	mov	r4, r3
c0de0316:	d000      	beq.n	c0de031a <adjustDecimals+0xb2>
c0de0318:	460c      	mov	r4, r1
c0de031a:	5cd1      	ldrb	r1, [r2, r3]
c0de031c:	2930      	cmp	r1, #48	; 0x30
c0de031e:	d000      	beq.n	c0de0322 <adjustDecimals+0xba>
c0de0320:	2400      	movs	r4, #0
    for (uint32_t i = startOffset; i < offset; i++) {
c0de0322:	1c5b      	adds	r3, r3, #1
c0de0324:	4621      	mov	r1, r4
c0de0326:	e7f2      	b.n	c0de030e <adjustDecimals+0xa6>
c0de0328:	2001      	movs	r0, #1
    if (lastZeroOffset != 0) {
c0de032a:	2900      	cmp	r1, #0
c0de032c:	d006      	beq.n	c0de033c <adjustDecimals+0xd4>
c0de032e:	2300      	movs	r3, #0
        target[lastZeroOffset] = '\0';
c0de0330:	5453      	strb	r3, [r2, r1]
        if (target[lastZeroOffset - 1] == '.') {
c0de0332:	1e49      	subs	r1, r1, #1
c0de0334:	5c54      	ldrb	r4, [r2, r1]
c0de0336:	2c2e      	cmp	r4, #46	; 0x2e
c0de0338:	d100      	bne.n	c0de033c <adjustDecimals+0xd4>
            target[lastZeroOffset - 1] = '\0';
c0de033a:	5453      	strb	r3, [r2, r1]
}
c0de033c:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
c0de033e:	d4d4      	bmi.n	c0de02ea <adjustDecimals+0x82>

c0de0340 <uint256_to_decimal>:
bool uint256_to_decimal(const uint8_t *value, size_t value_len, char *out, size_t out_len) {
c0de0340:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de0342:	b08b      	sub	sp, #44	; 0x2c
c0de0344:	9201      	str	r2, [sp, #4]
    if (value_len > INT256_LENGTH) {
c0de0346:	2920      	cmp	r1, #32
c0de0348:	d817      	bhi.n	c0de037a <uint256_to_decimal+0x3a>
c0de034a:	460e      	mov	r6, r1
c0de034c:	4607      	mov	r7, r0
c0de034e:	9300      	str	r3, [sp, #0]
c0de0350:	ad03      	add	r5, sp, #12
c0de0352:	2420      	movs	r4, #32
    uint16_t n[16] = {0};
c0de0354:	4628      	mov	r0, r5
c0de0356:	4621      	mov	r1, r4
c0de0358:	f000 ff74 	bl	c0de1244 <__aeabi_memclr>
    memcpy((uint8_t *) n + INT256_LENGTH - value_len, value, value_len);
c0de035c:	1ba8      	subs	r0, r5, r6
c0de035e:	3020      	adds	r0, #32
c0de0360:	4639      	mov	r1, r7
c0de0362:	4632      	mov	r2, r6
c0de0364:	f000 ff74 	bl	c0de1250 <__aeabi_memcpy>
    if (allzeroes(n, INT256_LENGTH)) {
c0de0368:	4628      	mov	r0, r5
c0de036a:	4621      	mov	r1, r4
c0de036c:	f000 f850 	bl	c0de0410 <allzeroes>
c0de0370:	2800      	cmp	r0, #0
c0de0372:	d004      	beq.n	c0de037e <uint256_to_decimal+0x3e>
c0de0374:	9a00      	ldr	r2, [sp, #0]
        if (out_len < 2) {
c0de0376:	2a02      	cmp	r2, #2
c0de0378:	d230      	bcs.n	c0de03dc <uint256_to_decimal+0x9c>
c0de037a:	2600      	movs	r6, #0
c0de037c:	e042      	b.n	c0de0404 <uint256_to_decimal+0xc4>
c0de037e:	2000      	movs	r0, #0
c0de0380:	9b00      	ldr	r3, [sp, #0]
    for (int i = 0; i < 16; i++) {
c0de0382:	2820      	cmp	r0, #32
c0de0384:	d005      	beq.n	c0de0392 <uint256_to_decimal+0x52>
c0de0386:	a903      	add	r1, sp, #12
        n[i] = __builtin_bswap16(*p++);
c0de0388:	5a0a      	ldrh	r2, [r1, r0]
c0de038a:	ba52      	rev16	r2, r2
c0de038c:	520a      	strh	r2, [r1, r0]
    for (int i = 0; i < 16; i++) {
c0de038e:	1c80      	adds	r0, r0, #2
c0de0390:	e7f7      	b.n	c0de0382 <uint256_to_decimal+0x42>
c0de0392:	9302      	str	r3, [sp, #8]
c0de0394:	a803      	add	r0, sp, #12
c0de0396:	2120      	movs	r1, #32
    while (!allzeroes(n, sizeof(n))) {
c0de0398:	f000 f83a 	bl	c0de0410 <allzeroes>
c0de039c:	4606      	mov	r6, r0
c0de039e:	2800      	cmp	r0, #0
c0de03a0:	d123      	bne.n	c0de03ea <uint256_to_decimal+0xaa>
        if (pos == 0) {
c0de03a2:	9802      	ldr	r0, [sp, #8]
c0de03a4:	2800      	cmp	r0, #0
c0de03a6:	d02b      	beq.n	c0de0400 <uint256_to_decimal+0xc0>
c0de03a8:	2600      	movs	r6, #0
c0de03aa:	4630      	mov	r0, r6
        for (int i = 0; i < 16; i++) {
c0de03ac:	2e20      	cmp	r6, #32
c0de03ae:	d00d      	beq.n	c0de03cc <uint256_to_decimal+0x8c>
c0de03b0:	af03      	add	r7, sp, #12
            int rem = ((carry << 16) | n[i]) % 10;
c0de03b2:	5bb9      	ldrh	r1, [r7, r6]
c0de03b4:	0400      	lsls	r0, r0, #16
c0de03b6:	1844      	adds	r4, r0, r1
c0de03b8:	250a      	movs	r5, #10
            n[i] = ((carry << 16) | n[i]) / 10;
c0de03ba:	4620      	mov	r0, r4
c0de03bc:	4629      	mov	r1, r5
c0de03be:	f000 fd6f 	bl	c0de0ea0 <__udivsi3>
c0de03c2:	53b8      	strh	r0, [r7, r6]
c0de03c4:	4345      	muls	r5, r0
c0de03c6:	1b60      	subs	r0, r4, r5
        for (int i = 0; i < 16; i++) {
c0de03c8:	1cb6      	adds	r6, r6, #2
c0de03ca:	e7ef      	b.n	c0de03ac <uint256_to_decimal+0x6c>
c0de03cc:	2130      	movs	r1, #48	; 0x30
        out[pos] = '0' + carry;
c0de03ce:	4308      	orrs	r0, r1
c0de03d0:	9a02      	ldr	r2, [sp, #8]
        pos -= 1;
c0de03d2:	1e52      	subs	r2, r2, #1
        out[pos] = '0' + carry;
c0de03d4:	9901      	ldr	r1, [sp, #4]
c0de03d6:	9202      	str	r2, [sp, #8]
c0de03d8:	5488      	strb	r0, [r1, r2]
c0de03da:	e7db      	b.n	c0de0394 <uint256_to_decimal+0x54>
        strlcpy(out, "0", out_len);
c0de03dc:	490b      	ldr	r1, [pc, #44]	; (c0de040c <uint256_to_decimal+0xcc>)
c0de03de:	4479      	add	r1, pc
c0de03e0:	9801      	ldr	r0, [sp, #4]
c0de03e2:	f001 f8c1 	bl	c0de1568 <strlcpy>
c0de03e6:	2601      	movs	r6, #1
c0de03e8:	e00c      	b.n	c0de0404 <uint256_to_decimal+0xc4>
c0de03ea:	9d01      	ldr	r5, [sp, #4]
c0de03ec:	9a02      	ldr	r2, [sp, #8]
    memmove(out, out + pos, out_len - pos);
c0de03ee:	18a9      	adds	r1, r5, r2
c0de03f0:	9800      	ldr	r0, [sp, #0]
c0de03f2:	1a84      	subs	r4, r0, r2
c0de03f4:	4628      	mov	r0, r5
c0de03f6:	4622      	mov	r2, r4
c0de03f8:	f000 ff2e 	bl	c0de1258 <__aeabi_memmove>
c0de03fc:	2000      	movs	r0, #0
    out[out_len - pos] = 0;
c0de03fe:	5528      	strb	r0, [r5, r4]
    while (!allzeroes(n, sizeof(n))) {
c0de0400:	1e70      	subs	r0, r6, #1
c0de0402:	4186      	sbcs	r6, r0
}
c0de0404:	4630      	mov	r0, r6
c0de0406:	b00b      	add	sp, #44	; 0x2c
c0de0408:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0de040a:	46c0      	nop			; (mov r8, r8)
c0de040c:	00001400 	.word	0x00001400

c0de0410 <allzeroes>:
typedef union extraInfo_t {
    tokenDefinition_t token;
    nftInfo_t nft;
} extraInfo_t;

static __attribute__((no_instrument_function)) inline int allzeroes(const void *buf, size_t n) {
c0de0410:	b510      	push	{r4, lr}
c0de0412:	2300      	movs	r3, #0
c0de0414:	461a      	mov	r2, r3
    uint8_t *p = (uint8_t *) buf;
    for (size_t i = 0; i < n; ++i) {
c0de0416:	4299      	cmp	r1, r3
c0de0418:	d003      	beq.n	c0de0422 <allzeroes+0x12>
        if (p[i]) {
c0de041a:	5c84      	ldrb	r4, [r0, r2]
    for (size_t i = 0; i < n; ++i) {
c0de041c:	1c53      	adds	r3, r2, #1
        if (p[i]) {
c0de041e:	2c00      	cmp	r4, #0
c0de0420:	d0f8      	beq.n	c0de0414 <allzeroes+0x4>
    for (size_t i = 0; i < n; ++i) {
c0de0422:	428a      	cmp	r2, r1
c0de0424:	d201      	bcs.n	c0de042a <allzeroes+0x1a>
c0de0426:	2000      	movs	r0, #0
            return 0;
        }
    }
    return 1;
}
c0de0428:	bd10      	pop	{r4, pc}
c0de042a:	2001      	movs	r0, #1
c0de042c:	bd10      	pop	{r4, pc}

c0de042e <amountToString>:
                    size_t out_buffer_size) {
c0de042e:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de0430:	b09d      	sub	sp, #116	; 0x74
c0de0432:	9303      	str	r3, [sp, #12]
c0de0434:	9202      	str	r2, [sp, #8]
c0de0436:	460c      	mov	r4, r1
c0de0438:	4605      	mov	r5, r0
c0de043a:	af04      	add	r7, sp, #16
c0de043c:	2664      	movs	r6, #100	; 0x64
    char tmp_buffer[100] = {0};
c0de043e:	4638      	mov	r0, r7
c0de0440:	4631      	mov	r1, r6
c0de0442:	f000 feff 	bl	c0de1244 <__aeabi_memclr>
    if (uint256_to_decimal(amount, amount_size, tmp_buffer, sizeof(tmp_buffer)) == false) {
c0de0446:	4628      	mov	r0, r5
c0de0448:	4621      	mov	r1, r4
c0de044a:	463a      	mov	r2, r7
c0de044c:	4633      	mov	r3, r6
c0de044e:	f7ff ff77 	bl	c0de0340 <uint256_to_decimal>
c0de0452:	2800      	cmp	r0, #0
c0de0454:	d02e      	beq.n	c0de04b4 <amountToString+0x86>
c0de0456:	9e23      	ldr	r6, [sp, #140]	; 0x8c
c0de0458:	9d22      	ldr	r5, [sp, #136]	; 0x88
c0de045a:	a804      	add	r0, sp, #16
c0de045c:	2164      	movs	r1, #100	; 0x64
    uint8_t amount_len = strnlen(tmp_buffer, sizeof(tmp_buffer));
c0de045e:	f001 f8dd 	bl	c0de161c <strnlen>
c0de0462:	9001      	str	r0, [sp, #4]
c0de0464:	210b      	movs	r1, #11
    uint8_t ticker_len = strnlen(ticker, MAX_TICKER_LEN);
c0de0466:	9803      	ldr	r0, [sp, #12]
c0de0468:	f001 f8d8 	bl	c0de161c <strnlen>
c0de046c:	4604      	mov	r4, r0
    memcpy(out_buffer, ticker, MIN(out_buffer_size, ticker_len));
c0de046e:	b2c7      	uxtb	r7, r0
c0de0470:	42b7      	cmp	r7, r6
c0de0472:	4632      	mov	r2, r6
c0de0474:	d800      	bhi.n	c0de0478 <amountToString+0x4a>
c0de0476:	463a      	mov	r2, r7
c0de0478:	4628      	mov	r0, r5
c0de047a:	9903      	ldr	r1, [sp, #12]
c0de047c:	f000 fee8 	bl	c0de1250 <__aeabi_memcpy>
    if (ticker_len > 0) {
c0de0480:	2f00      	cmp	r7, #0
c0de0482:	d004      	beq.n	c0de048e <amountToString+0x60>
c0de0484:	2020      	movs	r0, #32
        out_buffer[ticker_len++] = ' ';
c0de0486:	55e8      	strb	r0, [r5, r7]
c0de0488:	1c60      	adds	r0, r4, #1
                       out_buffer + ticker_len,
c0de048a:	b2c0      	uxtb	r0, r0
c0de048c:	e000      	b.n	c0de0490 <amountToString+0x62>
c0de048e:	2000      	movs	r0, #0
c0de0490:	9902      	ldr	r1, [sp, #8]
    if (adjustDecimals(tmp_buffer,
c0de0492:	9100      	str	r1, [sp, #0]
                       out_buffer + ticker_len,
c0de0494:	182a      	adds	r2, r5, r0
                       out_buffer_size - ticker_len - 1,
c0de0496:	43c0      	mvns	r0, r0
c0de0498:	1983      	adds	r3, r0, r6
                       amount_len,
c0de049a:	9801      	ldr	r0, [sp, #4]
c0de049c:	b2c1      	uxtb	r1, r0
c0de049e:	a804      	add	r0, sp, #16
    if (adjustDecimals(tmp_buffer,
c0de04a0:	f7ff fee2 	bl	c0de0268 <adjustDecimals>
c0de04a4:	2800      	cmp	r0, #0
c0de04a6:	d005      	beq.n	c0de04b4 <amountToString+0x86>
    out_buffer[out_buffer_size - 1] = '\0';
c0de04a8:	1970      	adds	r0, r6, r5
c0de04aa:	1e40      	subs	r0, r0, #1
c0de04ac:	2100      	movs	r1, #0
c0de04ae:	7001      	strb	r1, [r0, #0]
}
c0de04b0:	b01d      	add	sp, #116	; 0x74
c0de04b2:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0de04b4:	2007      	movs	r0, #7
c0de04b6:	f000 fad5 	bl	c0de0a64 <os_longjmp>

c0de04ba <copy_address>:

void copy_address(uint8_t* dst, const uint8_t* parameter, uint8_t dst_size) {
c0de04ba:	b580      	push	{r7, lr}
    uint8_t copy_size = MIN(dst_size, ADDRESS_LENGTH);
c0de04bc:	2a14      	cmp	r2, #20
c0de04be:	d300      	bcc.n	c0de04c2 <copy_address+0x8>
c0de04c0:	2214      	movs	r2, #20
    memmove(dst, parameter + PARAMETER_LENGTH - copy_size, copy_size);
c0de04c2:	1a89      	subs	r1, r1, r2
c0de04c4:	3120      	adds	r1, #32
c0de04c6:	f000 fec7 	bl	c0de1258 <__aeabi_memmove>
}
c0de04ca:	bd80      	pop	{r7, pc}

c0de04cc <copy_parameter>:

void copy_parameter(uint8_t* dst, const uint8_t* parameter, uint8_t dst_size) {
c0de04cc:	b580      	push	{r7, lr}
    uint8_t copy_size = MIN(dst_size, PARAMETER_LENGTH);
c0de04ce:	2a20      	cmp	r2, #32
c0de04d0:	d300      	bcc.n	c0de04d4 <copy_parameter+0x8>
c0de04d2:	2220      	movs	r2, #32
    memmove(dst, parameter, copy_size);
c0de04d4:	f000 fec0 	bl	c0de1258 <__aeabi_memmove>
}
c0de04d8:	bd80      	pop	{r7, pc}
c0de04da:	d4d4      	bmi.n	c0de0486 <amountToString+0x58>

c0de04dc <find_contract_info>:
// or type: cd tests && npm run harvest-update
#include "contracts-info.txt"
#endif
};

contract_info_t *find_contract_info(const char *address) {
c0de04dc:	b570      	push	{r4, r5, r6, lr}
c0de04de:	4604      	mov	r4, r0
    int len = sizeof(contracts) / sizeof(contracts[0]);
    PRINTF("Contracts length: %d\n", len);
c0de04e0:	480e      	ldr	r0, [pc, #56]	; (c0de051c <find_contract_info+0x40>)
c0de04e2:	4478      	add	r0, pc
c0de04e4:	2105      	movs	r1, #5
c0de04e6:	f000 fadd 	bl	c0de0aa4 <mcu_usb_printf>
c0de04ea:	2077      	movs	r0, #119	; 0x77
c0de04ec:	43c0      	mvns	r0, r0
c0de04ee:	4d0c      	ldr	r5, [pc, #48]	; (c0de0520 <find_contract_info+0x44>)
c0de04f0:	447d      	add	r5, pc
    for (int i = 0; i < len; i++) {
c0de04f2:	4606      	mov	r6, r0
c0de04f4:	3614      	adds	r6, #20
c0de04f6:	d00e      	beq.n	c0de0516 <find_contract_info+0x3a>
        contract_info_t *ci = &contracts[i];
        if (memcmp(address, (char *) PIC(ci->address), 42) == 0) return ci;
c0de04f8:	1828      	adds	r0, r5, r0
c0de04fa:	6f80      	ldr	r0, [r0, #120]	; 0x78
c0de04fc:	f000 fc66 	bl	c0de0dcc <pic>
c0de0500:	4601      	mov	r1, r0
c0de0502:	222a      	movs	r2, #42	; 0x2a
c0de0504:	4620      	mov	r0, r4
c0de0506:	f000 feb3 	bl	c0de1270 <memcmp>
c0de050a:	2800      	cmp	r0, #0
c0de050c:	4630      	mov	r0, r6
c0de050e:	d1f1      	bne.n	c0de04f4 <find_contract_info+0x18>
c0de0510:	19a8      	adds	r0, r5, r6
c0de0512:	3064      	adds	r0, #100	; 0x64
    }
    // when contract is not found
    return NULL;
}
c0de0514:	bd70      	pop	{r4, r5, r6, pc}
c0de0516:	2000      	movs	r0, #0
c0de0518:	bd70      	pop	{r4, r5, r6, pc}
c0de051a:	46c0      	nop			; (mov r8, r8)
c0de051c:	000013c2 	.word	0x000013c2
c0de0520:	000014e0 	.word	0x000014e0

c0de0524 <handle_finalize>:

void handle_finalize(void *parameters) {
c0de0524:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de0526:	b085      	sub	sp, #20
c0de0528:	4604      	mov	r4, r0
    ethPluginFinalize_t *msg = (ethPluginFinalize_t *) parameters;
    context_t *context = (context_t *) msg->pluginContext;
c0de052a:	6885      	ldr	r5, [r0, #8]
c0de052c:	208d      	movs	r0, #141	; 0x8d

    selector_t selectorIndex = context->selectorIndex;
c0de052e:	5c28      	ldrb	r0, [r5, r0]
    msg->numScreens = selectorIndex == POOL_GET_REWARD || selectorIndex == POOL_EXIT ? 1 : 2;
c0de0530:	1ec1      	subs	r1, r0, #3
c0de0532:	2902      	cmp	r1, #2
c0de0534:	d301      	bcc.n	c0de053a <handle_finalize+0x16>
c0de0536:	2102      	movs	r1, #2
c0de0538:	e000      	b.n	c0de053c <handle_finalize+0x18>
c0de053a:	2101      	movs	r1, #1
c0de053c:	7761      	strb	r1, [r4, #29]
c0de053e:	2120      	movs	r1, #32
c0de0540:	2230      	movs	r2, #48	; 0x30

    // Fill context underlying and vault ticker/decimals
    char *addr = context->contract_address;
    addr[0] = '0';
c0de0542:	546a      	strb	r2, [r5, r1]
c0de0544:	462e      	mov	r6, r5
c0de0546:	3620      	adds	r6, #32
c0de0548:	2178      	movs	r1, #120	; 0x78
    addr[1] = 'x';
c0de054a:	7071      	strb	r1, [r6, #1]

    uint64_t chainId = 0;

    if (selectorIndex != WIDO_EXECUTE_ORDER) {
c0de054c:	2805      	cmp	r0, #5
c0de054e:	d031      	beq.n	c0de05b4 <handle_finalize+0x90>
        getEthAddressStringFromBinary(msg->pluginSharedRO->txContent->destination,
                                    addr + 2,  // +2 here because we've already prefixed with '0x'.
                                    msg->pluginSharedRW->sha3,
c0de0550:	cc03      	ldmia	r4!, {r0, r1}
c0de0552:	6802      	ldr	r2, [r0, #0]
        getEthAddressStringFromBinary(msg->pluginSharedRO->txContent->destination,
c0de0554:	6808      	ldr	r0, [r1, #0]
c0de0556:	2100      	movs	r1, #0
c0de0558:	9100      	str	r1, [sp, #0]
c0de055a:	9101      	str	r1, [sp, #4]
                                    addr + 2,  // +2 here because we've already prefixed with '0x'.
c0de055c:	4629      	mov	r1, r5
c0de055e:	3122      	adds	r1, #34	; 0x22
        getEthAddressStringFromBinary(msg->pluginSharedRO->txContent->destination,
c0de0560:	30a5      	adds	r0, #165	; 0xa5
                                    msg->pluginSharedRW->sha3,
c0de0562:	3c08      	subs	r4, #8
        getEthAddressStringFromBinary(msg->pluginSharedRO->txContent->destination,
c0de0564:	f7ff fdb8 	bl	c0de00d8 <getEthAddressStringFromBinary>
                                    chainId);
        PRINTF("MSG Address: %s\n", addr);
c0de0568:	4816      	ldr	r0, [pc, #88]	; (c0de05c4 <handle_finalize+0xa0>)
c0de056a:	4478      	add	r0, pc
c0de056c:	4631      	mov	r1, r6
c0de056e:	f000 fa99 	bl	c0de0aa4 <mcu_usb_printf>

        contract_info_t *info = find_contract_info(addr);
c0de0572:	4630      	mov	r0, r6
c0de0574:	f7ff ffb2 	bl	c0de04dc <find_contract_info>

        if (info == NULL) {  // if contract info is not found
c0de0578:	2800      	cmp	r0, #0
c0de057a:	d01f      	beq.n	c0de05bc <handle_finalize+0x98>
c0de057c:	4607      	mov	r7, r0
c0de057e:	4628      	mov	r0, r5
c0de0580:	304b      	adds	r0, #75	; 0x4b
c0de0582:	9004      	str	r0, [sp, #16]
            msg->result = ETH_PLUGIN_RESULT_UNAVAILABLE;

        } else {
            strlcpy(context->underlying_ticker,
                    (char *) PIC(info->underlying_ticker),
c0de0584:	6878      	ldr	r0, [r7, #4]
c0de0586:	f000 fc21 	bl	c0de0dcc <pic>
c0de058a:	4601      	mov	r1, r0
            strlcpy(context->underlying_ticker,
c0de058c:	4628      	mov	r0, r5
c0de058e:	3034      	adds	r0, #52	; 0x34
c0de0590:	220b      	movs	r2, #11
c0de0592:	9203      	str	r2, [sp, #12]
c0de0594:	f000 ffe8 	bl	c0de1568 <strlcpy>
                    sizeof(context->underlying_ticker));
            context->underlying_decimals = info->underlying_decimals;
c0de0598:	7a38      	ldrb	r0, [r7, #8]
c0de059a:	77f0      	strb	r0, [r6, #31]
            strlcpy(context->vault_ticker,
                    (char *) PIC(info->vault_ticker),
c0de059c:	68f8      	ldr	r0, [r7, #12]
c0de059e:	f000 fc15 	bl	c0de0dcc <pic>
c0de05a2:	4601      	mov	r1, r0
            strlcpy(context->vault_ticker,
c0de05a4:	3540      	adds	r5, #64	; 0x40
c0de05a6:	4628      	mov	r0, r5
c0de05a8:	9a03      	ldr	r2, [sp, #12]
c0de05aa:	f000 ffdd 	bl	c0de1568 <strlcpy>
                    sizeof(context->vault_ticker));
            context->vault_decimals = info->vault_decimals;
c0de05ae:	7c38      	ldrb	r0, [r7, #16]
c0de05b0:	9904      	ldr	r1, [sp, #16]
c0de05b2:	7008      	strb	r0, [r1, #0]
c0de05b4:	2002      	movs	r0, #2
c0de05b6:	7720      	strb	r0, [r4, #28]
c0de05b8:	2004      	movs	r0, #4
c0de05ba:	e000      	b.n	c0de05be <handle_finalize+0x9a>
c0de05bc:	2001      	movs	r0, #1
c0de05be:	77a0      	strb	r0, [r4, #30]
        }
    } else {
        msg->uiType = ETH_UI_TYPE_GENERIC;
        msg->result = ETH_PLUGIN_RESULT_OK;
    }
}
c0de05c0:	b005      	add	sp, #20
c0de05c2:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0de05c4:	000013ff 	.word	0x000013ff

c0de05c8 <handle_init_contract>:
    }
    return -1;
}

// Called once to init.
void handle_init_contract(void *parameters) {
c0de05c8:	b570      	push	{r4, r5, r6, lr}
c0de05ca:	4604      	mov	r4, r0
    // Cast the msg to the type of structure we expect (here, ethPluginInitContract_t).
    ethPluginInitContract_t *msg = (ethPluginInitContract_t *) parameters;

    // Make sure we are running a compatible version.
    if (msg->interfaceVersion != ETH_PLUGIN_INTERFACE_VERSION_LATEST) {
c0de05cc:	7800      	ldrb	r0, [r0, #0]
c0de05ce:	2601      	movs	r6, #1
c0de05d0:	2806      	cmp	r0, #6
c0de05d2:	d107      	bne.n	c0de05e4 <handle_init_contract+0x1c>
        return;
    }

    // Double check that the `context_t` struct is not bigger than the maximum size (defined by
    // `msg->pluginContextLength`).
    if (msg->pluginContextLength < sizeof(context_t)) {
c0de05d4:	6920      	ldr	r0, [r4, #16]
c0de05d6:	288e      	cmp	r0, #142	; 0x8e
c0de05d8:	d806      	bhi.n	c0de05e8 <handle_init_contract+0x20>
        PRINTF("Plugin parameters structure is bigger than allowed size\n");
c0de05da:	481d      	ldr	r0, [pc, #116]	; (c0de0650 <handle_init_contract+0x88>)
c0de05dc:	4478      	add	r0, pc
c0de05de:	f000 fa61 	bl	c0de0aa4 <mcu_usb_printf>
c0de05e2:	2600      	movs	r6, #0
c0de05e4:	7066      	strb	r6, [r4, #1]
            return;
    }

    // Return valid status.
    msg->result = ETH_PLUGIN_RESULT_OK;
}
c0de05e6:	bd70      	pop	{r4, r5, r6, pc}
    context_t *context = (context_t *) msg->pluginContext;
c0de05e8:	68e5      	ldr	r5, [r4, #12]
c0de05ea:	218f      	movs	r1, #143	; 0x8f
    memset(context, 0, sizeof(*context));
c0de05ec:	4628      	mov	r0, r5
c0de05ee:	f000 fe29 	bl	c0de1244 <__aeabi_memclr>
    uint32_t selector = U4BE(msg->selector, 0);
c0de05f2:	6960      	ldr	r0, [r4, #20]
#define U4(hi3, hi2, lo1,lo0) ((((hi3)&0xFFu)<<24) | (((hi2)&0xFFu)<<16) | (((lo1)&0xFFu)<<8) | ((lo0)&0xFFu))
static inline uint16_t U2BE(const uint8_t *buf, size_t off) {
  return (buf[off] << 8) | buf[off + 1];
}
static inline uint32_t U4BE(const uint8_t *buf, size_t off) {
  return (((uint32_t)buf[off]) << 24) | (buf[off + 1] << 16) | (buf[off + 2] << 8) | buf[off + 3];
c0de05f4:	7801      	ldrb	r1, [r0, #0]
c0de05f6:	0609      	lsls	r1, r1, #24
c0de05f8:	7842      	ldrb	r2, [r0, #1]
c0de05fa:	0412      	lsls	r2, r2, #16
c0de05fc:	1851      	adds	r1, r2, r1
c0de05fe:	7882      	ldrb	r2, [r0, #2]
c0de0600:	0212      	lsls	r2, r2, #8
c0de0602:	1889      	adds	r1, r1, r2
c0de0604:	78c0      	ldrb	r0, [r0, #3]
c0de0606:	1808      	adds	r0, r1, r0
c0de0608:	358c      	adds	r5, #140	; 0x8c
c0de060a:	2100      	movs	r1, #0
c0de060c:	4a11      	ldr	r2, [pc, #68]	; (c0de0654 <handle_init_contract+0x8c>)
c0de060e:	447a      	add	r2, pc
    for (selector_t i = 0; i < n; i++) {
c0de0610:	2906      	cmp	r1, #6
c0de0612:	d0e7      	beq.n	c0de05e4 <handle_init_contract+0x1c>
        if (selector == selectors[i]) {
c0de0614:	6813      	ldr	r3, [r2, #0]
c0de0616:	4283      	cmp	r3, r0
c0de0618:	d002      	beq.n	c0de0620 <handle_init_contract+0x58>
    for (selector_t i = 0; i < n; i++) {
c0de061a:	1d12      	adds	r2, r2, #4
c0de061c:	1c49      	adds	r1, r1, #1
c0de061e:	e7f7      	b.n	c0de0610 <handle_init_contract+0x48>
            *out = i;
c0de0620:	7069      	strb	r1, [r5, #1]
    if (find_selector(selector, HARVEST_SELECTORS, NUM_SELECTORS, &context->selectorIndex)) {
c0de0622:	2905      	cmp	r1, #5
c0de0624:	d8de      	bhi.n	c0de05e4 <handle_init_contract+0x1c>
            *out = i;
c0de0626:	b2c8      	uxtb	r0, r1
    switch (context->selectorIndex) {
c0de0628:	2803      	cmp	r0, #3
c0de062a:	d308      	bcc.n	c0de063e <handle_init_contract+0x76>
c0de062c:	1ec2      	subs	r2, r0, #3
c0de062e:	2a02      	cmp	r2, #2
c0de0630:	d303      	bcc.n	c0de063a <handle_init_contract+0x72>
c0de0632:	2805      	cmp	r0, #5
c0de0634:	d107      	bne.n	c0de0646 <handle_init_contract+0x7e>
c0de0636:	200a      	movs	r0, #10
            context->next_param = FROM_ADDRESS;
c0de0638:	7028      	strb	r0, [r5, #0]
c0de063a:	2001      	movs	r0, #1
c0de063c:	e000      	b.n	c0de0640 <handle_init_contract+0x78>
c0de063e:	2000      	movs	r0, #0
c0de0640:	7028      	strb	r0, [r5, #0]
c0de0642:	2604      	movs	r6, #4
c0de0644:	e7ce      	b.n	c0de05e4 <handle_init_contract+0x1c>
            PRINTF("Missing selectorIndex: %d\n", context->selectorIndex);
c0de0646:	4804      	ldr	r0, [pc, #16]	; (c0de0658 <handle_init_contract+0x90>)
c0de0648:	4478      	add	r0, pc
c0de064a:	f000 fa2b 	bl	c0de0aa4 <mcu_usb_printf>
c0de064e:	e7c8      	b.n	c0de05e2 <handle_init_contract+0x1a>
c0de0650:	000010af 	.word	0x000010af
c0de0654:	00001036 	.word	0x00001036
c0de0658:	00001341 	.word	0x00001341

c0de065c <handle_provide_parameter>:
            msg->result = ETH_PLUGIN_RESULT_ERROR;
            break;
    }
}

void handle_provide_parameter(void *parameters) {
c0de065c:	b570      	push	{r4, r5, r6, lr}
c0de065e:	4605      	mov	r5, r0
    ethPluginProvideParameter_t *msg = (ethPluginProvideParameter_t *) parameters;
    context_t *context = (context_t *) msg->pluginContext;
c0de0660:	6884      	ldr	r4, [r0, #8]
    // the number of bytes you wish to print (in this case, `PARAMETER_LENGTH`) and then
    // the address (here `msg->parameter`).
    PRINTF("plugin provide parameter: offset %d\nBytes: %.*H\n",
           msg->parameterOffset,
           PARAMETER_LENGTH,
           msg->parameter);
c0de0662:	68c3      	ldr	r3, [r0, #12]
           msg->parameterOffset,
c0de0664:	6901      	ldr	r1, [r0, #16]
    PRINTF("plugin provide parameter: offset %d\nBytes: %.*H\n",
c0de0666:	482c      	ldr	r0, [pc, #176]	; (c0de0718 <handle_provide_parameter+0xbc>)
c0de0668:	4478      	add	r0, pc
c0de066a:	2220      	movs	r2, #32
c0de066c:	f000 fa1a 	bl	c0de0aa4 <mcu_usb_printf>
c0de0670:	2004      	movs	r0, #4

    msg->result = ETH_PLUGIN_RESULT_OK;
c0de0672:	7528      	strb	r0, [r5, #20]
c0de0674:	208d      	movs	r0, #141	; 0x8d

    switch (context->selectorIndex) {
c0de0676:	5c21      	ldrb	r1, [r4, r0]
c0de0678:	4626      	mov	r6, r4
c0de067a:	368c      	adds	r6, #140	; 0x8c
c0de067c:	2903      	cmp	r1, #3
c0de067e:	d205      	bcs.n	c0de068c <handle_provide_parameter+0x30>
    switch (context->next_param) {
c0de0680:	7831      	ldrb	r1, [r6, #0]
c0de0682:	2900      	cmp	r1, #0
c0de0684:	d01a      	beq.n	c0de06bc <handle_provide_parameter+0x60>
c0de0686:	4827      	ldr	r0, [pc, #156]	; (c0de0724 <handle_provide_parameter+0xc8>)
c0de0688:	4478      	add	r0, pc
c0de068a:	e021      	b.n	c0de06d0 <handle_provide_parameter+0x74>
    switch (context->selectorIndex) {
c0de068c:	2905      	cmp	r1, #5
c0de068e:	d11d      	bne.n	c0de06cc <handle_provide_parameter+0x70>
    if (context->go_to_offset) {
c0de0690:	78b0      	ldrb	r0, [r6, #2]
c0de0692:	2800      	cmp	r0, #0
c0de0694:	d006      	beq.n	c0de06a4 <handle_provide_parameter+0x48>
c0de0696:	2051      	movs	r0, #81	; 0x51
c0de0698:	0080      	lsls	r0, r0, #2
        if (msg->parameterOffset != OFFSET_FROM_ADDRESS + SELECTOR_SIZE) {
c0de069a:	6929      	ldr	r1, [r5, #16]
c0de069c:	4281      	cmp	r1, r0
c0de069e:	d11b      	bne.n	c0de06d8 <handle_provide_parameter+0x7c>
c0de06a0:	2000      	movs	r0, #0
        context->go_to_offset = false;
c0de06a2:	70b0      	strb	r0, [r6, #2]
    switch (context->next_param) {
c0de06a4:	7831      	ldrb	r1, [r6, #0]
c0de06a6:	290b      	cmp	r1, #11
c0de06a8:	d017      	beq.n	c0de06da <handle_provide_parameter+0x7e>
c0de06aa:	290a      	cmp	r1, #10
c0de06ac:	d023      	beq.n	c0de06f6 <handle_provide_parameter+0x9a>
c0de06ae:	2901      	cmp	r1, #1
c0de06b0:	d1e9      	bne.n	c0de0686 <handle_provide_parameter+0x2a>
c0de06b2:	200a      	movs	r0, #10
            context->next_param = FROM_ADDRESS;
c0de06b4:	7030      	strb	r0, [r6, #0]
c0de06b6:	2001      	movs	r0, #1
            context->go_to_offset = true;
c0de06b8:	70b0      	strb	r0, [r6, #2]
        default:
            PRINTF("Selector Index not supported: %d\n", context->selectorIndex);
            msg->result = ETH_PLUGIN_RESULT_ERROR;
            break;
    }
}
c0de06ba:	bd70      	pop	{r4, r5, r6, pc}
            copy_parameter(context->amount, msg->parameter, sizeof(context->amount));
c0de06bc:	68e9      	ldr	r1, [r5, #12]
c0de06be:	2220      	movs	r2, #32
c0de06c0:	4620      	mov	r0, r4
c0de06c2:	f7ff ff03 	bl	c0de04cc <copy_parameter>
c0de06c6:	2001      	movs	r0, #1
c0de06c8:	7030      	strb	r0, [r6, #0]
}
c0de06ca:	bd70      	pop	{r4, r5, r6, pc}
            PRINTF("Selector Index not supported: %d\n", context->selectorIndex);
c0de06cc:	4816      	ldr	r0, [pc, #88]	; (c0de0728 <handle_provide_parameter+0xcc>)
c0de06ce:	4478      	add	r0, pc
c0de06d0:	f000 f9e8 	bl	c0de0aa4 <mcu_usb_printf>
c0de06d4:	2000      	movs	r0, #0
c0de06d6:	7528      	strb	r0, [r5, #20]
}
c0de06d8:	bd70      	pop	{r4, r5, r6, pc}
            copy_parameter(context->from_amount, msg->parameter, sizeof(context->from_amount));
c0de06da:	68e9      	ldr	r1, [r5, #12]
c0de06dc:	346c      	adds	r4, #108	; 0x6c
c0de06de:	2520      	movs	r5, #32
c0de06e0:	4620      	mov	r0, r4
c0de06e2:	462a      	mov	r2, r5
c0de06e4:	f7ff fef2 	bl	c0de04cc <copy_parameter>
            printf_hex_array("FROM_AMOUNT: ", INT256_LENGTH, context->from_amount);
c0de06e8:	480d      	ldr	r0, [pc, #52]	; (c0de0720 <handle_provide_parameter+0xc4>)
c0de06ea:	4478      	add	r0, pc
c0de06ec:	4629      	mov	r1, r5
c0de06ee:	4622      	mov	r2, r4
c0de06f0:	f000 f81c 	bl	c0de072c <printf_hex_array>
c0de06f4:	e7e7      	b.n	c0de06c6 <handle_provide_parameter+0x6a>
            copy_address(context->from_address, msg->parameter, sizeof(context->from_address));
c0de06f6:	68e9      	ldr	r1, [r5, #12]
c0de06f8:	344c      	adds	r4, #76	; 0x4c
c0de06fa:	2514      	movs	r5, #20
c0de06fc:	4620      	mov	r0, r4
c0de06fe:	462a      	mov	r2, r5
c0de0700:	f7ff fedb 	bl	c0de04ba <copy_address>
c0de0704:	200b      	movs	r0, #11
            context->next_param = FROM_AMOUNT;
c0de0706:	7030      	strb	r0, [r6, #0]
            printf_hex_array("FROM_ADDRESS: ", ADDRESS_LENGTH, context->from_address);
c0de0708:	4804      	ldr	r0, [pc, #16]	; (c0de071c <handle_provide_parameter+0xc0>)
c0de070a:	4478      	add	r0, pc
c0de070c:	4629      	mov	r1, r5
c0de070e:	4622      	mov	r2, r4
c0de0710:	f000 f80c 	bl	c0de072c <printf_hex_array>
}
c0de0714:	bd70      	pop	{r4, r5, r6, pc}
c0de0716:	46c0      	nop			; (mov r8, r8)
c0de0718:	000012c6 	.word	0x000012c6
c0de071c:	0000109e 	.word	0x0000109e
c0de0720:	00001208 	.word	0x00001208
c0de0724:	00001158 	.word	0x00001158
c0de0728:	0000119e 	.word	0x0000119e

c0de072c <printf_hex_array>:
    uint8_t vault_decimals;
} contract_info_t;

static inline void printf_hex_array(const char *title __attribute__((unused)),
                                    size_t len __attribute__((unused)),
                                    const uint8_t *data __attribute__((unused))) {
c0de072c:	b570      	push	{r4, r5, r6, lr}
c0de072e:	4614      	mov	r4, r2
c0de0730:	460d      	mov	r5, r1
    PRINTF(title);
c0de0732:	f000 f9b7 	bl	c0de0aa4 <mcu_usb_printf>
c0de0736:	4e08      	ldr	r6, [pc, #32]	; (c0de0758 <printf_hex_array+0x2c>)
c0de0738:	447e      	add	r6, pc
    for (size_t i = 0; i < len; ++i) {
c0de073a:	2d00      	cmp	r5, #0
c0de073c:	d006      	beq.n	c0de074c <printf_hex_array+0x20>
        PRINTF("%02x", data[i]);
c0de073e:	7821      	ldrb	r1, [r4, #0]
c0de0740:	4630      	mov	r0, r6
c0de0742:	f000 f9af 	bl	c0de0aa4 <mcu_usb_printf>
    for (size_t i = 0; i < len; ++i) {
c0de0746:	1c64      	adds	r4, r4, #1
c0de0748:	1e6d      	subs	r5, r5, #1
c0de074a:	e7f6      	b.n	c0de073a <printf_hex_array+0xe>
    };
    PRINTF("\n");
c0de074c:	4803      	ldr	r0, [pc, #12]	; (c0de075c <printf_hex_array+0x30>)
c0de074e:	4478      	add	r0, pc
c0de0750:	f000 f9a8 	bl	c0de0aa4 <mcu_usb_printf>
c0de0754:	bd70      	pop	{r4, r5, r6, pc}
c0de0756:	46c0      	nop			; (mov r8, r8)
c0de0758:	0000107f 	.word	0x0000107f
c0de075c:	00001196 	.word	0x00001196

c0de0760 <handle_provide_token>:
#include "harvest_plugin.h"

void handle_provide_token(void *parameters) {
c0de0760:	b5fe      	push	{r1, r2, r3, r4, r5, r6, r7, lr}
c0de0762:	4604      	mov	r4, r0
    ethPluginProvideInfo_t *msg = (ethPluginProvideInfo_t *) parameters;
    context_t *context = (context_t *) msg->pluginContext;
c0de0764:	6885      	ldr	r5, [r0, #8]
c0de0766:	2020      	movs	r0, #32
c0de0768:	2130      	movs	r1, #48	; 0x30


    // Fill context wido from token ticker/decimals
    char *from_addr = context->contract_address;
    from_addr[0] = '0';
c0de076a:	5429      	strb	r1, [r5, r0]
c0de076c:	462f      	mov	r7, r5
c0de076e:	3720      	adds	r7, #32
c0de0770:	2078      	movs	r0, #120	; 0x78
    from_addr[1] = 'x';
c0de0772:	7078      	strb	r0, [r7, #1]

    uint64_t chainId = 0;

    getEthAddressStringFromBinary(context->from_address,
        from_addr + 2,  // +2 here because we've already prefixed with '0x'.
        msg->pluginSharedRW->sha3,
c0de0774:	6820      	ldr	r0, [r4, #0]
c0de0776:	6802      	ldr	r2, [r0, #0]
c0de0778:	2000      	movs	r0, #0
    getEthAddressStringFromBinary(context->from_address,
c0de077a:	9000      	str	r0, [sp, #0]
c0de077c:	9001      	str	r0, [sp, #4]
c0de077e:	4628      	mov	r0, r5
c0de0780:	304c      	adds	r0, #76	; 0x4c
        from_addr + 2,  // +2 here because we've already prefixed with '0x'.
c0de0782:	1cb9      	adds	r1, r7, #2
    getEthAddressStringFromBinary(context->from_address,
c0de0784:	f7ff fca8 	bl	c0de00d8 <getEthAddressStringFromBinary>
        chainId);
    PRINTF("Wido plugin provide token: 0x%p\n", msg->item1);
c0de0788:	68e1      	ldr	r1, [r4, #12]
c0de078a:	4816      	ldr	r0, [pc, #88]	; (c0de07e4 <handle_provide_token+0x84>)
c0de078c:	4478      	add	r0, pc
c0de078e:	f000 f989 	bl	c0de0aa4 <mcu_usb_printf>
c0de0792:	462e      	mov	r6, r5
c0de0794:	366b      	adds	r6, #107	; 0x6b
    if(from_addr == ZERO_ADDRESS) {
c0de0796:	4814      	ldr	r0, [pc, #80]	; (c0de07e8 <handle_provide_token+0x88>)
c0de0798:	4478      	add	r0, pc
c0de079a:	3560      	adds	r5, #96	; 0x60
c0de079c:	4287      	cmp	r7, r0
c0de079e:	d00a      	beq.n	c0de07b6 <handle_provide_token+0x56>
        strlcpy(context->from_address_ticker, "ETH", sizeof(context->from_address_ticker));
        context->from_address_decimals = 18;
    } else if (msg->item1 != NULL) {
c0de07a0:	68e1      	ldr	r1, [r4, #12]
c0de07a2:	2900      	cmp	r1, #0
c0de07a4:	d010      	beq.n	c0de07c8 <handle_provide_token+0x68>
        strlcpy(context->from_address_ticker, (char *) msg->item1->token.ticker, sizeof(context->from_address_ticker));
c0de07a6:	3114      	adds	r1, #20
c0de07a8:	220b      	movs	r2, #11
c0de07aa:	4628      	mov	r0, r5
c0de07ac:	f000 fedc 	bl	c0de1568 <strlcpy>
        context->from_address_decimals = msg->item1->token.decimals;
c0de07b0:	68e0      	ldr	r0, [r4, #12]
c0de07b2:	7fc0      	ldrb	r0, [r0, #31]
c0de07b4:	e006      	b.n	c0de07c4 <handle_provide_token+0x64>
        strlcpy(context->from_address_ticker, "ETH", sizeof(context->from_address_ticker));
c0de07b6:	490d      	ldr	r1, [pc, #52]	; (c0de07ec <handle_provide_token+0x8c>)
c0de07b8:	4479      	add	r1, pc
c0de07ba:	220b      	movs	r2, #11
c0de07bc:	4628      	mov	r0, r5
c0de07be:	f000 fed3 	bl	c0de1568 <strlcpy>
c0de07c2:	2012      	movs	r0, #18
c0de07c4:	7030      	strb	r0, [r6, #0]
c0de07c6:	e00a      	b.n	c0de07de <handle_provide_token+0x7e>
    } else {
        strlcpy(context->from_address_ticker, "???", sizeof(context->from_address_ticker));
c0de07c8:	4909      	ldr	r1, [pc, #36]	; (c0de07f0 <handle_provide_token+0x90>)
c0de07ca:	4479      	add	r1, pc
c0de07cc:	220b      	movs	r2, #11
c0de07ce:	4628      	mov	r0, r5
c0de07d0:	f000 feca 	bl	c0de1568 <strlcpy>
c0de07d4:	2012      	movs	r0, #18
        context->from_address_decimals = 18;
c0de07d6:	7030      	strb	r0, [r6, #0]
        msg->additionalScreens++;
c0de07d8:	7d20      	ldrb	r0, [r4, #20]
c0de07da:	1c40      	adds	r0, r0, #1
c0de07dc:	7520      	strb	r0, [r4, #20]
c0de07de:	2004      	movs	r0, #4
    }
    msg->result = ETH_PLUGIN_RESULT_OK;
c0de07e0:	7560      	strb	r0, [r4, #21]
}
c0de07e2:	bdfe      	pop	{r1, r2, r3, r4, r5, r6, r7, pc}
c0de07e4:	0000112e 	.word	0x0000112e
c0de07e8:	00000ec8 	.word	0x00000ec8
c0de07ec:	00001069 	.word	0x00001069
c0de07f0:	00001111 	.word	0x00001111

c0de07f4 <set_msg>:
#include "harvest_plugin.h"

void set_msg(ethQueryContractID_t *msg, char *text) {
c0de07f4:	b580      	push	{r7, lr}
    strlcpy(msg->version, text, msg->versionLength);
c0de07f6:	6943      	ldr	r3, [r0, #20]
c0de07f8:	6982      	ldr	r2, [r0, #24]
c0de07fa:	4618      	mov	r0, r3
c0de07fc:	f000 feb4 	bl	c0de1568 <strlcpy>
}
c0de0800:	bd80      	pop	{r7, pc}
c0de0802:	d4d4      	bmi.n	c0de07ae <handle_provide_token+0x4e>

c0de0804 <handle_query_contract_id>:

// Sets the first screen to display.
void handle_query_contract_id(void *parameters) {
c0de0804:	b5b0      	push	{r4, r5, r7, lr}
c0de0806:	4604      	mov	r4, r0
    ethQueryContractID_t *msg = (ethQueryContractID_t *) parameters;
    const context_t *context = (const context_t *) msg->pluginContext;
c0de0808:	6885      	ldr	r5, [r0, #8]
    // msg->name will be the upper sentence displayed on the screen.
    // msg->version will be the lower sentence displayed on the screen.

    // For the first screen, display the plugin name.
    strlcpy(msg->name, PLUGIN_NAME, msg->nameLength);
c0de080a:	68c0      	ldr	r0, [r0, #12]
c0de080c:	6922      	ldr	r2, [r4, #16]
c0de080e:	4918      	ldr	r1, [pc, #96]	; (c0de0870 <handle_query_contract_id+0x6c>)
c0de0810:	4479      	add	r1, pc
c0de0812:	f000 fea9 	bl	c0de1568 <strlcpy>
c0de0816:	2004      	movs	r0, #4

    msg->result = ETH_PLUGIN_RESULT_OK;
c0de0818:	7720      	strb	r0, [r4, #28]
c0de081a:	208d      	movs	r0, #141	; 0x8d
    selector_t selectorIndex = context->selectorIndex;
c0de081c:	5c29      	ldrb	r1, [r5, r0]

    switch (selectorIndex) {
c0de081e:	2905      	cmp	r1, #5
c0de0820:	d00c      	beq.n	c0de083c <handle_query_contract_id+0x38>
c0de0822:	2901      	cmp	r1, #1
c0de0824:	d00d      	beq.n	c0de0842 <handle_query_contract_id+0x3e>
c0de0826:	2902      	cmp	r1, #2
c0de0828:	d00e      	beq.n	c0de0848 <handle_query_contract_id+0x44>
c0de082a:	2903      	cmp	r1, #3
c0de082c:	d00f      	beq.n	c0de084e <handle_query_contract_id+0x4a>
c0de082e:	2904      	cmp	r1, #4
c0de0830:	d010      	beq.n	c0de0854 <handle_query_contract_id+0x50>
c0de0832:	2900      	cmp	r1, #0
c0de0834:	d114      	bne.n	c0de0860 <handle_query_contract_id+0x5c>
        case VAULT_DEPOSIT:
            set_msg(msg, "Deposit");
c0de0836:	490f      	ldr	r1, [pc, #60]	; (c0de0874 <handle_query_contract_id+0x70>)
c0de0838:	4479      	add	r1, pc
c0de083a:	e00d      	b.n	c0de0858 <handle_query_contract_id+0x54>
            break;
        case POOL_GET_REWARD:
            set_msg(msg, "Claim");
            break;
        case WIDO_EXECUTE_ORDER:
            set_msg(msg, "Wido Execute");
c0de083c:	4912      	ldr	r1, [pc, #72]	; (c0de0888 <handle_query_contract_id+0x84>)
c0de083e:	4479      	add	r1, pc
c0de0840:	e00a      	b.n	c0de0858 <handle_query_contract_id+0x54>
            set_msg(msg, "Withdraw");
c0de0842:	490d      	ldr	r1, [pc, #52]	; (c0de0878 <handle_query_contract_id+0x74>)
c0de0844:	4479      	add	r1, pc
c0de0846:	e007      	b.n	c0de0858 <handle_query_contract_id+0x54>
            set_msg(msg, "Stake");
c0de0848:	490c      	ldr	r1, [pc, #48]	; (c0de087c <handle_query_contract_id+0x78>)
c0de084a:	4479      	add	r1, pc
c0de084c:	e004      	b.n	c0de0858 <handle_query_contract_id+0x54>
            set_msg(msg, "Claim");
c0de084e:	490d      	ldr	r1, [pc, #52]	; (c0de0884 <handle_query_contract_id+0x80>)
c0de0850:	4479      	add	r1, pc
c0de0852:	e001      	b.n	c0de0858 <handle_query_contract_id+0x54>
            set_msg(msg, "Exit");
c0de0854:	490a      	ldr	r1, [pc, #40]	; (c0de0880 <handle_query_contract_id+0x7c>)
c0de0856:	4479      	add	r1, pc
c0de0858:	4620      	mov	r0, r4
c0de085a:	f7ff ffcb 	bl	c0de07f4 <set_msg>
        default:
            PRINTF("Selector index: %d not supported\n", selectorIndex);
            msg->result = ETH_PLUGIN_RESULT_ERROR;
            break;
    }
}
c0de085e:	bdb0      	pop	{r4, r5, r7, pc}
            PRINTF("Selector index: %d not supported\n", selectorIndex);
c0de0860:	480a      	ldr	r0, [pc, #40]	; (c0de088c <handle_query_contract_id+0x88>)
c0de0862:	4478      	add	r0, pc
c0de0864:	f000 f91e 	bl	c0de0aa4 <mcu_usb_printf>
c0de0868:	2000      	movs	r0, #0
            msg->result = ETH_PLUGIN_RESULT_ERROR;
c0de086a:	7720      	strb	r0, [r4, #28]
}
c0de086c:	bdb0      	pop	{r4, r5, r7, pc}
c0de086e:	46c0      	nop			; (mov r8, r8)
c0de0870:	00000fac 	.word	0x00000fac
c0de0874:	00001142 	.word	0x00001142
c0de0878:	0000111b 	.word	0x0000111b
c0de087c:	00000faf 	.word	0x00000faf
c0de0880:	00000fdd 	.word	0x00000fdd
c0de0884:	00000f88 	.word	0x00000f88
c0de0888:	000010c2 	.word	0x000010c2
c0de088c:	00000e8d 	.word	0x00000e8d

c0de0890 <handle_query_contract_ui>:
static void set_warn_ui(ethQueryContractUI_t *msg, context_t *context) {
    strlcpy(msg->title, "WARNING", msg->titleLength);
    strlcpy(msg->msg, "Unknown token", msg->msgLength);
}

void handle_query_contract_ui(void *parameters) {
c0de0890:	b5fe      	push	{r1, r2, r3, r4, r5, r6, r7, lr}
c0de0892:	4605      	mov	r5, r0
    ethQueryContractUI_t *msg = (ethQueryContractUI_t *) parameters;
    context_t *context = (context_t *) msg->pluginContext;
c0de0894:	69c4      	ldr	r4, [r0, #28]

    // msg->title is the upper line displayed on the device.
    // msg->msg is the lower line displayed on the device.

    // Clean the display fields.
    memset(msg->title, 0, msg->titleLength);
c0de0896:	6a40      	ldr	r0, [r0, #36]	; 0x24
c0de0898:	6aa9      	ldr	r1, [r5, #40]	; 0x28
c0de089a:	f000 fcd3 	bl	c0de1244 <__aeabi_memclr>
    memset(msg->msg, 0, msg->msgLength);
c0de089e:	6ae8      	ldr	r0, [r5, #44]	; 0x2c
c0de08a0:	6b29      	ldr	r1, [r5, #48]	; 0x30
c0de08a2:	f000 fccf 	bl	c0de1244 <__aeabi_memclr>
c0de08a6:	462e      	mov	r6, r5
c0de08a8:	3620      	adds	r6, #32
c0de08aa:	2004      	movs	r0, #4

    msg->result = ETH_PLUGIN_RESULT_OK;
c0de08ac:	7530      	strb	r0, [r6, #20]
c0de08ae:	2020      	movs	r0, #32

    switch (msg->screenIndex) {
c0de08b0:	5c28      	ldrb	r0, [r5, r0]
c0de08b2:	2802      	cmp	r0, #2
c0de08b4:	d00b      	beq.n	c0de08ce <handle_query_contract_ui+0x3e>
c0de08b6:	4627      	mov	r7, r4
c0de08b8:	378d      	adds	r7, #141	; 0x8d
c0de08ba:	2801      	cmp	r0, #1
c0de08bc:	d012      	beq.n	c0de08e4 <handle_query_contract_ui+0x54>
c0de08be:	2800      	cmp	r0, #0
c0de08c0:	d126      	bne.n	c0de0910 <handle_query_contract_ui+0x80>
    switch (context->selectorIndex) {
c0de08c2:	7838      	ldrb	r0, [r7, #0]
c0de08c4:	2802      	cmp	r0, #2
c0de08c6:	d22a      	bcs.n	c0de091e <handle_query_contract_ui+0x8e>
c0de08c8:	4937      	ldr	r1, [pc, #220]	; (c0de09a8 <handle_query_contract_ui+0x118>)
c0de08ca:	4479      	add	r1, pc
c0de08cc:	e02e      	b.n	c0de092c <handle_query_contract_ui+0x9c>
    strlcpy(msg->title, "WARNING", msg->titleLength);
c0de08ce:	6a68      	ldr	r0, [r5, #36]	; 0x24
c0de08d0:	6aaa      	ldr	r2, [r5, #40]	; 0x28
c0de08d2:	493a      	ldr	r1, [pc, #232]	; (c0de09bc <handle_query_contract_ui+0x12c>)
c0de08d4:	4479      	add	r1, pc
c0de08d6:	f000 fe47 	bl	c0de1568 <strlcpy>
    strlcpy(msg->msg, "Unknown token", msg->msgLength);
c0de08da:	6ae8      	ldr	r0, [r5, #44]	; 0x2c
c0de08dc:	6b2a      	ldr	r2, [r5, #48]	; 0x30
c0de08de:	4938      	ldr	r1, [pc, #224]	; (c0de09c0 <handle_query_contract_ui+0x130>)
c0de08e0:	4479      	add	r1, pc
c0de08e2:	e02e      	b.n	c0de0942 <handle_query_contract_ui+0xb2>
c0de08e4:	4620      	mov	r0, r4
c0de08e6:	303f      	adds	r0, #63	; 0x3f
c0de08e8:	9002      	str	r0, [sp, #8]
    strlcpy(msg->title, "Amount", msg->titleLength);
c0de08ea:	6a68      	ldr	r0, [r5, #36]	; 0x24
c0de08ec:	6aaa      	ldr	r2, [r5, #40]	; 0x28
c0de08ee:	4931      	ldr	r1, [pc, #196]	; (c0de09b4 <handle_query_contract_ui+0x124>)
c0de08f0:	4479      	add	r1, pc
c0de08f2:	f000 fe39 	bl	c0de1568 <strlcpy>
    switch (context->selectorIndex) {
c0de08f6:	7839      	ldrb	r1, [r7, #0]
c0de08f8:	2900      	cmp	r1, #0
c0de08fa:	d005      	beq.n	c0de0908 <handle_query_contract_ui+0x78>
c0de08fc:	2901      	cmp	r1, #1
c0de08fe:	d033      	beq.n	c0de0968 <handle_query_contract_ui+0xd8>
c0de0900:	2905      	cmp	r1, #5
c0de0902:	d03d      	beq.n	c0de0980 <handle_query_contract_ui+0xf0>
c0de0904:	2902      	cmp	r1, #2
c0de0906:	d14a      	bne.n	c0de099e <handle_query_contract_ui+0x10e>
            ticker = context->underlying_ticker;
c0de0908:	4623      	mov	r3, r4
c0de090a:	3334      	adds	r3, #52	; 0x34
c0de090c:	9802      	ldr	r0, [sp, #8]
c0de090e:	e02f      	b.n	c0de0970 <handle_query_contract_ui+0xe0>
        case 2:
            set_warn_ui(msg, context);
            break;
        // Keep this
        default:
            PRINTF("Received an invalid screenIndex\n");
c0de0910:	482c      	ldr	r0, [pc, #176]	; (c0de09c4 <handle_query_contract_ui+0x134>)
c0de0912:	4478      	add	r0, pc
c0de0914:	f000 f8c6 	bl	c0de0aa4 <mcu_usb_printf>
c0de0918:	2000      	movs	r0, #0
c0de091a:	7530      	strb	r0, [r6, #20]
            msg->result = ETH_PLUGIN_RESULT_ERROR;
            return;
    }
}
c0de091c:	bdfe      	pop	{r1, r2, r3, r4, r5, r6, r7, pc}
    switch (context->selectorIndex) {
c0de091e:	2805      	cmp	r0, #5
c0de0920:	d102      	bne.n	c0de0928 <handle_query_contract_ui+0x98>
c0de0922:	4922      	ldr	r1, [pc, #136]	; (c0de09ac <handle_query_contract_ui+0x11c>)
c0de0924:	4479      	add	r1, pc
c0de0926:	e001      	b.n	c0de092c <handle_query_contract_ui+0x9c>
c0de0928:	4921      	ldr	r1, [pc, #132]	; (c0de09b0 <handle_query_contract_ui+0x120>)
c0de092a:	4479      	add	r1, pc
c0de092c:	6a68      	ldr	r0, [r5, #36]	; 0x24
c0de092e:	6aaa      	ldr	r2, [r5, #40]	; 0x28
c0de0930:	f000 fe1a 	bl	c0de1568 <strlcpy>
c0de0934:	6ae8      	ldr	r0, [r5, #44]	; 0x2c
    if (context->selectorIndex != WIDO_EXECUTE_ORDER) {
c0de0936:	7839      	ldrb	r1, [r7, #0]
c0de0938:	2905      	cmp	r1, #5
c0de093a:	d105      	bne.n	c0de0948 <handle_query_contract_ui+0xb8>
        strlcpy(m_ticker, context->from_address_ticker, sizeof(context->from_address_ticker));
c0de093c:	3460      	adds	r4, #96	; 0x60
c0de093e:	220b      	movs	r2, #11
c0de0940:	4621      	mov	r1, r4
c0de0942:	f000 fe11 	bl	c0de1568 <strlcpy>
}
c0de0946:	bdfe      	pop	{r1, r2, r3, r4, r5, r6, r7, pc}
c0de0948:	2178      	movs	r1, #120	; 0x78
        m[1] = 'x';
c0de094a:	7041      	strb	r1, [r0, #1]
c0de094c:	2130      	movs	r1, #48	; 0x30
        m[0] = '0';
c0de094e:	7001      	strb	r1, [r0, #0]
                                      msg->pluginSharedRW->sha3,
c0de0950:	cd0a      	ldmia	r5!, {r1, r3}
c0de0952:	680a      	ldr	r2, [r1, #0]
        getEthAddressStringFromBinary(msg->pluginSharedRO->txContent->destination,
c0de0954:	681b      	ldr	r3, [r3, #0]
c0de0956:	2100      	movs	r1, #0
c0de0958:	9100      	str	r1, [sp, #0]
c0de095a:	9101      	str	r1, [sp, #4]
                                      m + 2,  // +2 here because we've already prefixed with '0x'.
c0de095c:	1c81      	adds	r1, r0, #2
        getEthAddressStringFromBinary(msg->pluginSharedRO->txContent->destination,
c0de095e:	33a5      	adds	r3, #165	; 0xa5
c0de0960:	4618      	mov	r0, r3
c0de0962:	f7ff fbb9 	bl	c0de00d8 <getEthAddressStringFromBinary>
}
c0de0966:	bdfe      	pop	{r1, r2, r3, r4, r5, r6, r7, pc}
            ticker = context->vault_ticker;
c0de0968:	4623      	mov	r3, r4
c0de096a:	3340      	adds	r3, #64	; 0x40
c0de096c:	9802      	ldr	r0, [sp, #8]
            decimals = context->vault_decimals;
c0de096e:	300c      	adds	r0, #12
c0de0970:	7802      	ldrb	r2, [r0, #0]
                       msg->msg,
c0de0972:	6ae8      	ldr	r0, [r5, #44]	; 0x2c
                       msg->msgLength);
c0de0974:	6b29      	ldr	r1, [r5, #48]	; 0x30
        amountToString(context->amount,
c0de0976:	9000      	str	r0, [sp, #0]
c0de0978:	9101      	str	r1, [sp, #4]
c0de097a:	2120      	movs	r1, #32
c0de097c:	4620      	mov	r0, r4
c0de097e:	e00b      	b.n	c0de0998 <handle_query_contract_ui+0x108>
c0de0980:	4620      	mov	r0, r4
c0de0982:	306b      	adds	r0, #107	; 0x6b
c0de0984:	7802      	ldrb	r2, [r0, #0]
                       msg->msg,
c0de0986:	6ae8      	ldr	r0, [r5, #44]	; 0x2c
                       msg->msgLength);
c0de0988:	6b29      	ldr	r1, [r5, #48]	; 0x30
        amountToString(context->from_amount,
c0de098a:	9000      	str	r0, [sp, #0]
c0de098c:	9101      	str	r1, [sp, #4]
c0de098e:	4620      	mov	r0, r4
c0de0990:	306c      	adds	r0, #108	; 0x6c
            ticker = context->from_address_ticker;
c0de0992:	3460      	adds	r4, #96	; 0x60
c0de0994:	2120      	movs	r1, #32
        amountToString(context->from_amount,
c0de0996:	4623      	mov	r3, r4
c0de0998:	f7ff fd49 	bl	c0de042e <amountToString>
}
c0de099c:	bdfe      	pop	{r1, r2, r3, r4, r5, r6, r7, pc}
            PRINTF("Selector Index not supported: %d\n", context->selectorIndex);
c0de099e:	4806      	ldr	r0, [pc, #24]	; (c0de09b8 <handle_query_contract_ui+0x128>)
c0de09a0:	4478      	add	r0, pc
c0de09a2:	f000 f87f 	bl	c0de0aa4 <mcu_usb_printf>
c0de09a6:	e7b7      	b.n	c0de0918 <handle_query_contract_ui+0x88>
c0de09a8:	00000efa 	.word	0x00000efa
c0de09ac:	00000edb 	.word	0x00000edb
c0de09b0:	00000e45 	.word	0x00000e45
c0de09b4:	00000e84 	.word	0x00000e84
c0de09b8:	00000ecc 	.word	0x00000ecc
c0de09bc:	00000e68 	.word	0x00000e68
c0de09c0:	00000f45 	.word	0x00000f45
c0de09c4:	00000ffb 	.word	0x00000ffb

c0de09c8 <dispatch_plugin_calls>:
void dispatch_plugin_calls(int message, void *parameters) {
c0de09c8:	b580      	push	{r7, lr}
c0de09ca:	4602      	mov	r2, r0
c0de09cc:	2083      	movs	r0, #131	; 0x83
c0de09ce:	0040      	lsls	r0, r0, #1
    switch (message) {
c0de09d0:	4282      	cmp	r2, r0
c0de09d2:	d017      	beq.n	c0de0a04 <dispatch_plugin_calls+0x3c>
c0de09d4:	2081      	movs	r0, #129	; 0x81
c0de09d6:	0040      	lsls	r0, r0, #1
c0de09d8:	4282      	cmp	r2, r0
c0de09da:	d017      	beq.n	c0de0a0c <dispatch_plugin_calls+0x44>
c0de09dc:	20ff      	movs	r0, #255	; 0xff
c0de09de:	4603      	mov	r3, r0
c0de09e0:	3304      	adds	r3, #4
c0de09e2:	429a      	cmp	r2, r3
c0de09e4:	d016      	beq.n	c0de0a14 <dispatch_plugin_calls+0x4c>
c0de09e6:	2341      	movs	r3, #65	; 0x41
c0de09e8:	009b      	lsls	r3, r3, #2
c0de09ea:	429a      	cmp	r2, r3
c0de09ec:	d016      	beq.n	c0de0a1c <dispatch_plugin_calls+0x54>
c0de09ee:	4603      	mov	r3, r0
c0de09f0:	3306      	adds	r3, #6
c0de09f2:	429a      	cmp	r2, r3
c0de09f4:	d016      	beq.n	c0de0a24 <dispatch_plugin_calls+0x5c>
c0de09f6:	3002      	adds	r0, #2
c0de09f8:	4282      	cmp	r2, r0
c0de09fa:	d117      	bne.n	c0de0a2c <dispatch_plugin_calls+0x64>
            handle_init_contract(parameters);
c0de09fc:	4608      	mov	r0, r1
c0de09fe:	f7ff fde3 	bl	c0de05c8 <handle_init_contract>
}
c0de0a02:	bd80      	pop	{r7, pc}
            handle_query_contract_ui(parameters);
c0de0a04:	4608      	mov	r0, r1
c0de0a06:	f7ff ff43 	bl	c0de0890 <handle_query_contract_ui>
}
c0de0a0a:	bd80      	pop	{r7, pc}
            handle_provide_parameter(parameters);
c0de0a0c:	4608      	mov	r0, r1
c0de0a0e:	f7ff fe25 	bl	c0de065c <handle_provide_parameter>
}
c0de0a12:	bd80      	pop	{r7, pc}
            handle_finalize(parameters);
c0de0a14:	4608      	mov	r0, r1
c0de0a16:	f7ff fd85 	bl	c0de0524 <handle_finalize>
}
c0de0a1a:	bd80      	pop	{r7, pc}
            handle_provide_token(parameters);
c0de0a1c:	4608      	mov	r0, r1
c0de0a1e:	f7ff fe9f 	bl	c0de0760 <handle_provide_token>
}
c0de0a22:	bd80      	pop	{r7, pc}
            handle_query_contract_id(parameters);
c0de0a24:	4608      	mov	r0, r1
c0de0a26:	f7ff feed 	bl	c0de0804 <handle_query_contract_id>
}
c0de0a2a:	bd80      	pop	{r7, pc}
            PRINTF("Unhandled message %d\n", message);
c0de0a2c:	4802      	ldr	r0, [pc, #8]	; (c0de0a38 <dispatch_plugin_calls+0x70>)
c0de0a2e:	4478      	add	r0, pc
c0de0a30:	4611      	mov	r1, r2
c0de0a32:	f000 f837 	bl	c0de0aa4 <mcu_usb_printf>
}
c0de0a36:	bd80      	pop	{r7, pc}
c0de0a38:	00000e60 	.word	0x00000e60

c0de0a3c <call_app_ethereum>:
void call_app_ethereum() {
c0de0a3c:	b5f8      	push	{r3, r4, r5, r6, r7, lr}
    libcall_params[0] = (unsigned int) "Ethereum";
c0de0a3e:	4805      	ldr	r0, [pc, #20]	; (c0de0a54 <call_app_ethereum+0x18>)
c0de0a40:	4478      	add	r0, pc
c0de0a42:	9001      	str	r0, [sp, #4]
c0de0a44:	2001      	movs	r0, #1
    libcall_params[2] = RUN_APPLICATION;
c0de0a46:	9003      	str	r0, [sp, #12]
c0de0a48:	0200      	lsls	r0, r0, #8
    libcall_params[1] = 0x100;
c0de0a4a:	9002      	str	r0, [sp, #8]
c0de0a4c:	a801      	add	r0, sp, #4
    os_lib_call((unsigned int *) &libcall_params);
c0de0a4e:	f000 f9e9 	bl	c0de0e24 <os_lib_call>
}
c0de0a52:	bd8f      	pop	{r0, r1, r2, r3, r7, pc}
c0de0a54:	00000d8f 	.word	0x00000d8f

c0de0a58 <os_boot>:

// apdu buffer must hold a complete apdu to avoid troubles
unsigned char G_io_apdu_buffer[IO_APDU_BUFFER_SIZE];

#ifndef BOLOS_OS_UPGRADER_APP
void os_boot(void) {
c0de0a58:	b580      	push	{r7, lr}
c0de0a5a:	2000      	movs	r0, #0
  // // TODO patch entry point when romming (f)
  // // set the default try context to nothing
#ifndef HAVE_BOLOS
  try_context_set(NULL);
c0de0a5c:	f000 fa14 	bl	c0de0e88 <try_context_set>
#endif // HAVE_BOLOS
}
c0de0a60:	bd80      	pop	{r7, pc}
c0de0a62:	d4d4      	bmi.n	c0de0a0e <dispatch_plugin_calls+0x46>

c0de0a64 <os_longjmp>:
  }
  return xoracc;
}

#ifndef HAVE_BOLOS
void os_longjmp(unsigned int exception) {
c0de0a64:	4604      	mov	r4, r0
#ifdef HAVE_PRINTF
  unsigned int lr_val;
  __asm volatile("mov %0, lr" :"=r"(lr_val));
c0de0a66:	4672      	mov	r2, lr
  PRINTF("exception[%d]: LR=0x%08X\n", exception, lr_val);
c0de0a68:	4804      	ldr	r0, [pc, #16]	; (c0de0a7c <os_longjmp+0x18>)
c0de0a6a:	4478      	add	r0, pc
c0de0a6c:	4621      	mov	r1, r4
c0de0a6e:	f000 f819 	bl	c0de0aa4 <mcu_usb_printf>
#endif // HAVE_PRINTF
  longjmp(try_context_get()->jmp_buf, exception);
c0de0a72:	f000 fa01 	bl	c0de0e78 <try_context_get>
c0de0a76:	4621      	mov	r1, r4
c0de0a78:	f000 fd34 	bl	c0de14e4 <longjmp>
c0de0a7c:	00000ddf 	.word	0x00000ddf

c0de0a80 <mcu_usb_prints>:
  return ret;
}
#endif // !defined(APP_UX)

#ifdef HAVE_PRINTF
void mcu_usb_prints(const char* str, unsigned int charcount) {
c0de0a80:	b5bc      	push	{r2, r3, r4, r5, r7, lr}
c0de0a82:	460c      	mov	r4, r1
c0de0a84:	4605      	mov	r5, r0
c0de0a86:	a801      	add	r0, sp, #4
  buf[0] = SEPROXYHAL_TAG_PRINTF_STATUS;
#else
  buf[0] = SEPROXYHAL_TAG_PRINTF;
#endif
  buf[1] = charcount >> 8;
  buf[2] = charcount;
c0de0a88:	7081      	strb	r1, [r0, #2]
c0de0a8a:	215f      	movs	r1, #95	; 0x5f
  buf[0] = SEPROXYHAL_TAG_PRINTF;
c0de0a8c:	7001      	strb	r1, [r0, #0]
  buf[1] = charcount >> 8;
c0de0a8e:	0a21      	lsrs	r1, r4, #8
c0de0a90:	7041      	strb	r1, [r0, #1]
c0de0a92:	2103      	movs	r1, #3
  io_seproxyhal_spi_send(buf, 3);
c0de0a94:	f000 f9e6 	bl	c0de0e64 <io_seph_send>
  io_seproxyhal_spi_send((const uint8_t *) str, charcount);
c0de0a98:	b2a1      	uxth	r1, r4
c0de0a9a:	4628      	mov	r0, r5
c0de0a9c:	f000 f9e2 	bl	c0de0e64 <io_seph_send>
}
c0de0aa0:	bdbc      	pop	{r2, r3, r4, r5, r7, pc}
c0de0aa2:	d4d4      	bmi.n	c0de0a4e <call_app_ethereum+0x12>

c0de0aa4 <mcu_usb_printf>:
#ifdef HAVE_PRINTF
#include "os_io_seproxyhal.h"

void screen_printf(const char* format, ...) __attribute__ ((weak, alias ("mcu_usb_printf")));

void mcu_usb_printf(const char* format, ...) {
c0de0aa4:	b083      	sub	sp, #12
c0de0aa6:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de0aa8:	b08e      	sub	sp, #56	; 0x38
c0de0aaa:	ac13      	add	r4, sp, #76	; 0x4c
c0de0aac:	c40e      	stmia	r4!, {r1, r2, r3}
    char cStrlenSet;

    //
    // Check the arguments.
    //
    if(format == 0) {
c0de0aae:	2800      	cmp	r0, #0
c0de0ab0:	d100      	bne.n	c0de0ab4 <mcu_usb_printf+0x10>
c0de0ab2:	e16f      	b.n	c0de0d94 <mcu_usb_printf+0x2f0>
c0de0ab4:	4607      	mov	r7, r0
c0de0ab6:	a813      	add	r0, sp, #76	; 0x4c
    }

    //
    // Start the varargs processing.
    //
    va_start(vaArgP, format);
c0de0ab8:	9008      	str	r0, [sp, #32]
c0de0aba:	2001      	movs	r0, #1
c0de0abc:	9002      	str	r0, [sp, #8]

    //
    // Loop while there are more characters in the string.
    //
    while(*format)
c0de0abe:	7838      	ldrb	r0, [r7, #0]
c0de0ac0:	2800      	cmp	r0, #0
c0de0ac2:	d100      	bne.n	c0de0ac6 <mcu_usb_printf+0x22>
c0de0ac4:	e166      	b.n	c0de0d94 <mcu_usb_printf+0x2f0>
c0de0ac6:	463c      	mov	r4, r7
c0de0ac8:	2500      	movs	r5, #0
    {
        //
        // Find the first non-% character, or the end of the string.
        //
        for(ulIdx = 0; (format[ulIdx] != '%') && (format[ulIdx] != '\0');
c0de0aca:	2800      	cmp	r0, #0
c0de0acc:	d005      	beq.n	c0de0ada <mcu_usb_printf+0x36>
c0de0ace:	2825      	cmp	r0, #37	; 0x25
c0de0ad0:	d003      	beq.n	c0de0ada <mcu_usb_printf+0x36>
c0de0ad2:	1960      	adds	r0, r4, r5
c0de0ad4:	7840      	ldrb	r0, [r0, #1]
            ulIdx++)
c0de0ad6:	1c6d      	adds	r5, r5, #1
c0de0ad8:	e7f7      	b.n	c0de0aca <mcu_usb_printf+0x26>
        }

        //
        // Write this portion of the string.
        //
        mcu_usb_prints(format, ulIdx);
c0de0ada:	4620      	mov	r0, r4
c0de0adc:	4629      	mov	r1, r5
c0de0ade:	f7ff ffcf 	bl	c0de0a80 <mcu_usb_prints>
c0de0ae2:	1967      	adds	r7, r4, r5
        format += ulIdx;

        //
        // See if the next character is a %.
        //
        if(*format == '%')
c0de0ae4:	5d60      	ldrb	r0, [r4, r5]
c0de0ae6:	2825      	cmp	r0, #37	; 0x25
c0de0ae8:	d1e9      	bne.n	c0de0abe <mcu_usb_printf+0x1a>
            ulCount = 0;
            cFill = ' ';
            ulStrlen = 0;
            cStrlenSet = 0;
            ulCap = 0;
            ulBase = 10;
c0de0aea:	1960      	adds	r0, r4, r5
c0de0aec:	1c47      	adds	r7, r0, #1
c0de0aee:	2400      	movs	r4, #0
c0de0af0:	2320      	movs	r3, #32
c0de0af2:	9407      	str	r4, [sp, #28]
c0de0af4:	4622      	mov	r2, r4
c0de0af6:	4610      	mov	r0, r2
again:

            //
            // Determine how to handle the next character.
            //
            switch(*format++)
c0de0af8:	7839      	ldrb	r1, [r7, #0]
c0de0afa:	1c7f      	adds	r7, r7, #1
c0de0afc:	2200      	movs	r2, #0
c0de0afe:	292d      	cmp	r1, #45	; 0x2d
c0de0b00:	d0f9      	beq.n	c0de0af6 <mcu_usb_printf+0x52>
c0de0b02:	460a      	mov	r2, r1
c0de0b04:	3a30      	subs	r2, #48	; 0x30
c0de0b06:	2a0a      	cmp	r2, #10
c0de0b08:	d316      	bcc.n	c0de0b38 <mcu_usb_printf+0x94>
c0de0b0a:	2925      	cmp	r1, #37	; 0x25
c0de0b0c:	d045      	beq.n	c0de0b9a <mcu_usb_printf+0xf6>
c0de0b0e:	292a      	cmp	r1, #42	; 0x2a
c0de0b10:	9703      	str	r7, [sp, #12]
c0de0b12:	d020      	beq.n	c0de0b56 <mcu_usb_printf+0xb2>
c0de0b14:	292e      	cmp	r1, #46	; 0x2e
c0de0b16:	d129      	bne.n	c0de0b6c <mcu_usb_printf+0xc8>
                // special %.*H or %.*h format to print a given length of hex digits (case: H UPPER, h lower)
                //
                case '.':
                {
                  // ensure next char is '*' and next one is 's'
                  if (format[0] == '*' && (format[1] == 's' || format[1] == 'H' || format[1] == 'h')) {
c0de0b18:	7838      	ldrb	r0, [r7, #0]
c0de0b1a:	282a      	cmp	r0, #42	; 0x2a
c0de0b1c:	d17b      	bne.n	c0de0c16 <mcu_usb_printf+0x172>
c0de0b1e:	9803      	ldr	r0, [sp, #12]
c0de0b20:	7840      	ldrb	r0, [r0, #1]
c0de0b22:	2848      	cmp	r0, #72	; 0x48
c0de0b24:	d003      	beq.n	c0de0b2e <mcu_usb_printf+0x8a>
c0de0b26:	2873      	cmp	r0, #115	; 0x73
c0de0b28:	d001      	beq.n	c0de0b2e <mcu_usb_printf+0x8a>
c0de0b2a:	2868      	cmp	r0, #104	; 0x68
c0de0b2c:	d173      	bne.n	c0de0c16 <mcu_usb_printf+0x172>
c0de0b2e:	9f03      	ldr	r7, [sp, #12]
c0de0b30:	1c7f      	adds	r7, r7, #1
c0de0b32:	2201      	movs	r2, #1

                    // skip '*' char
                    format++;

                    ulStrlen = va_arg(vaArgP, unsigned long);
c0de0b34:	9808      	ldr	r0, [sp, #32]
c0de0b36:	e014      	b.n	c0de0b62 <mcu_usb_printf+0xbe>
c0de0b38:	9304      	str	r3, [sp, #16]
c0de0b3a:	2230      	movs	r2, #48	; 0x30
                    if((format[-1] == '0') && (ulCount == 0))
c0de0b3c:	460b      	mov	r3, r1
c0de0b3e:	4053      	eors	r3, r2
c0de0b40:	4626      	mov	r6, r4
c0de0b42:	4323      	orrs	r3, r4
c0de0b44:	d000      	beq.n	c0de0b48 <mcu_usb_printf+0xa4>
c0de0b46:	9a04      	ldr	r2, [sp, #16]
c0de0b48:	230a      	movs	r3, #10
                    ulCount *= 10;
c0de0b4a:	4373      	muls	r3, r6
                    ulCount += format[-1] - '0';
c0de0b4c:	185c      	adds	r4, r3, r1
c0de0b4e:	3c30      	subs	r4, #48	; 0x30
c0de0b50:	4613      	mov	r3, r2
c0de0b52:	4602      	mov	r2, r0
c0de0b54:	e7cf      	b.n	c0de0af6 <mcu_usb_printf+0x52>
                  goto error;
                }

                case '*':
                {
                  if (*format == 's' ) {
c0de0b56:	7838      	ldrb	r0, [r7, #0]
c0de0b58:	2873      	cmp	r0, #115	; 0x73
c0de0b5a:	d15c      	bne.n	c0de0c16 <mcu_usb_printf+0x172>
c0de0b5c:	2202      	movs	r2, #2

                    ulStrlen = va_arg(vaArgP, unsigned long);
c0de0b5e:	9808      	ldr	r0, [sp, #32]
c0de0b60:	9f03      	ldr	r7, [sp, #12]
c0de0b62:	1d01      	adds	r1, r0, #4
c0de0b64:	9108      	str	r1, [sp, #32]
c0de0b66:	6800      	ldr	r0, [r0, #0]
            switch(*format++)
c0de0b68:	9007      	str	r0, [sp, #28]
c0de0b6a:	e7c4      	b.n	c0de0af6 <mcu_usb_printf+0x52>
c0de0b6c:	2948      	cmp	r1, #72	; 0x48
c0de0b6e:	d016      	beq.n	c0de0b9e <mcu_usb_printf+0xfa>
c0de0b70:	2958      	cmp	r1, #88	; 0x58
c0de0b72:	d018      	beq.n	c0de0ba6 <mcu_usb_printf+0x102>
c0de0b74:	2963      	cmp	r1, #99	; 0x63
c0de0b76:	d021      	beq.n	c0de0bbc <mcu_usb_printf+0x118>
c0de0b78:	2964      	cmp	r1, #100	; 0x64
c0de0b7a:	d029      	beq.n	c0de0bd0 <mcu_usb_printf+0x12c>
c0de0b7c:	4f88      	ldr	r7, [pc, #544]	; (c0de0da0 <mcu_usb_printf+0x2fc>)
c0de0b7e:	447f      	add	r7, pc
c0de0b80:	2968      	cmp	r1, #104	; 0x68
c0de0b82:	d034      	beq.n	c0de0bee <mcu_usb_printf+0x14a>
c0de0b84:	2970      	cmp	r1, #112	; 0x70
c0de0b86:	d005      	beq.n	c0de0b94 <mcu_usb_printf+0xf0>
c0de0b88:	2973      	cmp	r1, #115	; 0x73
c0de0b8a:	d033      	beq.n	c0de0bf4 <mcu_usb_printf+0x150>
c0de0b8c:	2975      	cmp	r1, #117	; 0x75
c0de0b8e:	d046      	beq.n	c0de0c1e <mcu_usb_printf+0x17a>
c0de0b90:	2978      	cmp	r1, #120	; 0x78
c0de0b92:	d140      	bne.n	c0de0c16 <mcu_usb_printf+0x172>
c0de0b94:	9304      	str	r3, [sp, #16]
c0de0b96:	2000      	movs	r0, #0
c0de0b98:	e007      	b.n	c0de0baa <mcu_usb_printf+0x106>
                case '%':
                {
                    //
                    // Simply write a single %.
                    //
                    mcu_usb_prints(format - 1, 1);
c0de0b9a:	1e78      	subs	r0, r7, #1
c0de0b9c:	e014      	b.n	c0de0bc8 <mcu_usb_printf+0x124>
c0de0b9e:	9406      	str	r4, [sp, #24]
c0de0ba0:	4f80      	ldr	r7, [pc, #512]	; (c0de0da4 <mcu_usb_printf+0x300>)
c0de0ba2:	447f      	add	r7, pc
c0de0ba4:	e024      	b.n	c0de0bf0 <mcu_usb_printf+0x14c>
c0de0ba6:	9304      	str	r3, [sp, #16]
c0de0ba8:	2001      	movs	r0, #1
c0de0baa:	9000      	str	r0, [sp, #0]
                    ulValue = va_arg(vaArgP, unsigned long);
c0de0bac:	9808      	ldr	r0, [sp, #32]
c0de0bae:	1d01      	adds	r1, r0, #4
c0de0bb0:	9108      	str	r1, [sp, #32]
c0de0bb2:	6800      	ldr	r0, [r0, #0]
c0de0bb4:	9005      	str	r0, [sp, #20]
c0de0bb6:	900d      	str	r0, [sp, #52]	; 0x34
c0de0bb8:	2010      	movs	r0, #16
c0de0bba:	e03a      	b.n	c0de0c32 <mcu_usb_printf+0x18e>
                    ulValue = va_arg(vaArgP, unsigned long);
c0de0bbc:	9808      	ldr	r0, [sp, #32]
c0de0bbe:	1d01      	adds	r1, r0, #4
c0de0bc0:	9108      	str	r1, [sp, #32]
c0de0bc2:	6800      	ldr	r0, [r0, #0]
c0de0bc4:	900d      	str	r0, [sp, #52]	; 0x34
c0de0bc6:	a80d      	add	r0, sp, #52	; 0x34
c0de0bc8:	2101      	movs	r1, #1
c0de0bca:	f7ff ff59 	bl	c0de0a80 <mcu_usb_prints>
c0de0bce:	e776      	b.n	c0de0abe <mcu_usb_printf+0x1a>
                    ulValue = va_arg(vaArgP, unsigned long);
c0de0bd0:	9808      	ldr	r0, [sp, #32]
c0de0bd2:	1d01      	adds	r1, r0, #4
c0de0bd4:	9108      	str	r1, [sp, #32]
c0de0bd6:	6800      	ldr	r0, [r0, #0]
c0de0bd8:	900d      	str	r0, [sp, #52]	; 0x34
c0de0bda:	210a      	movs	r1, #10
                    if((long)ulValue < 0)
c0de0bdc:	2800      	cmp	r0, #0
c0de0bde:	9304      	str	r3, [sp, #16]
c0de0be0:	9106      	str	r1, [sp, #24]
c0de0be2:	d500      	bpl.n	c0de0be6 <mcu_usb_printf+0x142>
c0de0be4:	e0c5      	b.n	c0de0d72 <mcu_usb_printf+0x2ce>
c0de0be6:	9005      	str	r0, [sp, #20]
c0de0be8:	2000      	movs	r0, #0
c0de0bea:	9000      	str	r0, [sp, #0]
c0de0bec:	e022      	b.n	c0de0c34 <mcu_usb_printf+0x190>
c0de0bee:	9406      	str	r4, [sp, #24]
c0de0bf0:	9902      	ldr	r1, [sp, #8]
c0de0bf2:	e001      	b.n	c0de0bf8 <mcu_usb_printf+0x154>
c0de0bf4:	9406      	str	r4, [sp, #24]
c0de0bf6:	2100      	movs	r1, #0
                    pcStr = va_arg(vaArgP, char *);
c0de0bf8:	9a08      	ldr	r2, [sp, #32]
c0de0bfa:	1d13      	adds	r3, r2, #4
c0de0bfc:	9308      	str	r3, [sp, #32]
                    switch(cStrlenSet) {
c0de0bfe:	b2c0      	uxtb	r0, r0
                    pcStr = va_arg(vaArgP, char *);
c0de0c00:	6814      	ldr	r4, [r2, #0]
                    switch(cStrlenSet) {
c0de0c02:	2800      	cmp	r0, #0
c0de0c04:	d074      	beq.n	c0de0cf0 <mcu_usb_printf+0x24c>
c0de0c06:	2801      	cmp	r0, #1
c0de0c08:	d079      	beq.n	c0de0cfe <mcu_usb_printf+0x25a>
c0de0c0a:	2802      	cmp	r0, #2
c0de0c0c:	d178      	bne.n	c0de0d00 <mcu_usb_printf+0x25c>
                        if (pcStr[0] == '\0') {
c0de0c0e:	7820      	ldrb	r0, [r4, #0]
c0de0c10:	2800      	cmp	r0, #0
c0de0c12:	d100      	bne.n	c0de0c16 <mcu_usb_printf+0x172>
c0de0c14:	e0b4      	b.n	c0de0d80 <mcu_usb_printf+0x2dc>
                default:
                {
                    //
                    // Indicate an error.
                    //
                    mcu_usb_prints("ERROR", 5);
c0de0c16:	4868      	ldr	r0, [pc, #416]	; (c0de0db8 <mcu_usb_printf+0x314>)
c0de0c18:	4478      	add	r0, pc
c0de0c1a:	2105      	movs	r1, #5
c0de0c1c:	e064      	b.n	c0de0ce8 <mcu_usb_printf+0x244>
c0de0c1e:	9304      	str	r3, [sp, #16]
                    ulValue = va_arg(vaArgP, unsigned long);
c0de0c20:	9808      	ldr	r0, [sp, #32]
c0de0c22:	1d01      	adds	r1, r0, #4
c0de0c24:	9108      	str	r1, [sp, #32]
c0de0c26:	6800      	ldr	r0, [r0, #0]
c0de0c28:	9005      	str	r0, [sp, #20]
c0de0c2a:	900d      	str	r0, [sp, #52]	; 0x34
c0de0c2c:	2000      	movs	r0, #0
c0de0c2e:	9000      	str	r0, [sp, #0]
c0de0c30:	200a      	movs	r0, #10
c0de0c32:	9006      	str	r0, [sp, #24]
c0de0c34:	9f02      	ldr	r7, [sp, #8]
c0de0c36:	4639      	mov	r1, r7
c0de0c38:	485d      	ldr	r0, [pc, #372]	; (c0de0db0 <mcu_usb_printf+0x30c>)
c0de0c3a:	4478      	add	r0, pc
                    for(ulIdx = 1;
c0de0c3c:	9007      	str	r0, [sp, #28]
c0de0c3e:	9101      	str	r1, [sp, #4]
c0de0c40:	19c8      	adds	r0, r1, r7
c0de0c42:	4038      	ands	r0, r7
c0de0c44:	1a26      	subs	r6, r4, r0
c0de0c46:	1e75      	subs	r5, r6, #1
c0de0c48:	2400      	movs	r4, #0
                        (((ulIdx * ulBase) <= ulValue) &&
c0de0c4a:	9806      	ldr	r0, [sp, #24]
c0de0c4c:	4621      	mov	r1, r4
c0de0c4e:	463a      	mov	r2, r7
c0de0c50:	4623      	mov	r3, r4
c0de0c52:	f000 f9d1 	bl	c0de0ff8 <__aeabi_lmul>
c0de0c56:	1e4a      	subs	r2, r1, #1
c0de0c58:	4191      	sbcs	r1, r2
c0de0c5a:	9a05      	ldr	r2, [sp, #20]
c0de0c5c:	4290      	cmp	r0, r2
c0de0c5e:	d805      	bhi.n	c0de0c6c <mcu_usb_printf+0x1c8>
                    for(ulIdx = 1;
c0de0c60:	2900      	cmp	r1, #0
c0de0c62:	d103      	bne.n	c0de0c6c <mcu_usb_printf+0x1c8>
c0de0c64:	1e6d      	subs	r5, r5, #1
c0de0c66:	1e76      	subs	r6, r6, #1
c0de0c68:	4607      	mov	r7, r0
c0de0c6a:	e7ed      	b.n	c0de0c48 <mcu_usb_printf+0x1a4>
                    if(ulNeg && (cFill == '0'))
c0de0c6c:	9801      	ldr	r0, [sp, #4]
c0de0c6e:	2800      	cmp	r0, #0
c0de0c70:	9802      	ldr	r0, [sp, #8]
c0de0c72:	9a04      	ldr	r2, [sp, #16]
c0de0c74:	d109      	bne.n	c0de0c8a <mcu_usb_printf+0x1e6>
c0de0c76:	b2d1      	uxtb	r1, r2
c0de0c78:	2000      	movs	r0, #0
c0de0c7a:	2930      	cmp	r1, #48	; 0x30
c0de0c7c:	4604      	mov	r4, r0
c0de0c7e:	d104      	bne.n	c0de0c8a <mcu_usb_printf+0x1e6>
c0de0c80:	a809      	add	r0, sp, #36	; 0x24
c0de0c82:	212d      	movs	r1, #45	; 0x2d
                        pcBuf[ulPos++] = '-';
c0de0c84:	7001      	strb	r1, [r0, #0]
c0de0c86:	2401      	movs	r4, #1
c0de0c88:	9802      	ldr	r0, [sp, #8]
                    if((ulCount > 1) && (ulCount < 16))
c0de0c8a:	1eb1      	subs	r1, r6, #2
c0de0c8c:	290d      	cmp	r1, #13
c0de0c8e:	d807      	bhi.n	c0de0ca0 <mcu_usb_printf+0x1fc>
c0de0c90:	9e06      	ldr	r6, [sp, #24]
                        for(ulCount--; ulCount; ulCount--)
c0de0c92:	2d00      	cmp	r5, #0
c0de0c94:	d005      	beq.n	c0de0ca2 <mcu_usb_printf+0x1fe>
c0de0c96:	a909      	add	r1, sp, #36	; 0x24
                            pcBuf[ulPos++] = cFill;
c0de0c98:	550a      	strb	r2, [r1, r4]
                        for(ulCount--; ulCount; ulCount--)
c0de0c9a:	1e6d      	subs	r5, r5, #1
                            pcBuf[ulPos++] = cFill;
c0de0c9c:	1c64      	adds	r4, r4, #1
c0de0c9e:	e7f8      	b.n	c0de0c92 <mcu_usb_printf+0x1ee>
c0de0ca0:	9e06      	ldr	r6, [sp, #24]
                    if(ulNeg)
c0de0ca2:	2800      	cmp	r0, #0
c0de0ca4:	9d05      	ldr	r5, [sp, #20]
c0de0ca6:	d103      	bne.n	c0de0cb0 <mcu_usb_printf+0x20c>
c0de0ca8:	a809      	add	r0, sp, #36	; 0x24
c0de0caa:	212d      	movs	r1, #45	; 0x2d
                        pcBuf[ulPos++] = '-';
c0de0cac:	5501      	strb	r1, [r0, r4]
c0de0cae:	1c64      	adds	r4, r4, #1
c0de0cb0:	9800      	ldr	r0, [sp, #0]
c0de0cb2:	2800      	cmp	r0, #0
c0de0cb4:	d114      	bne.n	c0de0ce0 <mcu_usb_printf+0x23c>
c0de0cb6:	483f      	ldr	r0, [pc, #252]	; (c0de0db4 <mcu_usb_printf+0x310>)
c0de0cb8:	4478      	add	r0, pc
c0de0cba:	9007      	str	r0, [sp, #28]
c0de0cbc:	e010      	b.n	c0de0ce0 <mcu_usb_printf+0x23c>
c0de0cbe:	4628      	mov	r0, r5
c0de0cc0:	4639      	mov	r1, r7
c0de0cc2:	f000 f8ed 	bl	c0de0ea0 <__udivsi3>
c0de0cc6:	4631      	mov	r1, r6
c0de0cc8:	f000 f970 	bl	c0de0fac <__aeabi_uidivmod>
c0de0ccc:	9807      	ldr	r0, [sp, #28]
c0de0cce:	5c40      	ldrb	r0, [r0, r1]
c0de0cd0:	a909      	add	r1, sp, #36	; 0x24
                          pcBuf[ulPos++] = g_pcHex[(ulValue / ulIdx) % ulBase];
c0de0cd2:	5508      	strb	r0, [r1, r4]
                    for(; ulIdx; ulIdx /= ulBase)
c0de0cd4:	4638      	mov	r0, r7
c0de0cd6:	4631      	mov	r1, r6
c0de0cd8:	f000 f8e2 	bl	c0de0ea0 <__udivsi3>
c0de0cdc:	4607      	mov	r7, r0
c0de0cde:	1c64      	adds	r4, r4, #1
c0de0ce0:	2f00      	cmp	r7, #0
c0de0ce2:	d1ec      	bne.n	c0de0cbe <mcu_usb_printf+0x21a>
c0de0ce4:	a809      	add	r0, sp, #36	; 0x24
                    mcu_usb_prints(pcBuf, ulPos);
c0de0ce6:	4621      	mov	r1, r4
c0de0ce8:	f7ff feca 	bl	c0de0a80 <mcu_usb_prints>
c0de0cec:	9f03      	ldr	r7, [sp, #12]
c0de0cee:	e6e6      	b.n	c0de0abe <mcu_usb_printf+0x1a>
c0de0cf0:	2000      	movs	r0, #0
                        for(ulIdx = 0; pcStr[ulIdx] != '\0'; ulIdx++)
c0de0cf2:	5c22      	ldrb	r2, [r4, r0]
c0de0cf4:	1c40      	adds	r0, r0, #1
c0de0cf6:	2a00      	cmp	r2, #0
c0de0cf8:	d1fb      	bne.n	c0de0cf2 <mcu_usb_printf+0x24e>
                    switch(ulBase) {
c0de0cfa:	1e45      	subs	r5, r0, #1
c0de0cfc:	e000      	b.n	c0de0d00 <mcu_usb_printf+0x25c>
c0de0cfe:	9d07      	ldr	r5, [sp, #28]
c0de0d00:	2900      	cmp	r1, #0
c0de0d02:	d01a      	beq.n	c0de0d3a <mcu_usb_printf+0x296>
c0de0d04:	2100      	movs	r1, #0
                        for (ulCount = 0; ulCount < ulIdx; ulCount++) {
c0de0d06:	2d00      	cmp	r5, #0
c0de0d08:	d02b      	beq.n	c0de0d62 <mcu_usb_printf+0x2be>
                          nibble1 = (pcStr[ulCount]>>4)&0xF;
c0de0d0a:	7820      	ldrb	r0, [r4, #0]
c0de0d0c:	0902      	lsrs	r2, r0, #4
c0de0d0e:	5cba      	ldrb	r2, [r7, r2]
c0de0d10:	ab09      	add	r3, sp, #36	; 0x24
c0de0d12:	545a      	strb	r2, [r3, r1]
c0de0d14:	185a      	adds	r2, r3, r1
c0de0d16:	230f      	movs	r3, #15
                          nibble2 = pcStr[ulCount]&0xF;
c0de0d18:	4003      	ands	r3, r0
c0de0d1a:	5cf8      	ldrb	r0, [r7, r3]
c0de0d1c:	7050      	strb	r0, [r2, #1]
c0de0d1e:	1c8a      	adds	r2, r1, #2
                          if (idx + 1 >= sizeof(pcBuf)) {
c0de0d20:	1cc8      	adds	r0, r1, #3
c0de0d22:	2810      	cmp	r0, #16
c0de0d24:	d201      	bcs.n	c0de0d2a <mcu_usb_printf+0x286>
c0de0d26:	4611      	mov	r1, r2
c0de0d28:	e004      	b.n	c0de0d34 <mcu_usb_printf+0x290>
c0de0d2a:	a809      	add	r0, sp, #36	; 0x24
                            mcu_usb_prints(pcBuf, idx);
c0de0d2c:	4611      	mov	r1, r2
c0de0d2e:	f7ff fea7 	bl	c0de0a80 <mcu_usb_prints>
c0de0d32:	2100      	movs	r1, #0
                        for (ulCount = 0; ulCount < ulIdx; ulCount++) {
c0de0d34:	1c64      	adds	r4, r4, #1
c0de0d36:	1e6d      	subs	r5, r5, #1
c0de0d38:	e7e5      	b.n	c0de0d06 <mcu_usb_printf+0x262>
                        mcu_usb_prints(pcStr, ulIdx);
c0de0d3a:	4620      	mov	r0, r4
c0de0d3c:	4629      	mov	r1, r5
c0de0d3e:	f7ff fe9f 	bl	c0de0a80 <mcu_usb_prints>
c0de0d42:	9f03      	ldr	r7, [sp, #12]
c0de0d44:	9806      	ldr	r0, [sp, #24]
                    if(ulCount > ulIdx)
c0de0d46:	42a8      	cmp	r0, r5
c0de0d48:	d800      	bhi.n	c0de0d4c <mcu_usb_printf+0x2a8>
c0de0d4a:	e6b8      	b.n	c0de0abe <mcu_usb_printf+0x1a>
                        while(ulCount--)
c0de0d4c:	1a2c      	subs	r4, r5, r0
c0de0d4e:	2c00      	cmp	r4, #0
c0de0d50:	d100      	bne.n	c0de0d54 <mcu_usb_printf+0x2b0>
c0de0d52:	e6b4      	b.n	c0de0abe <mcu_usb_printf+0x1a>
                            mcu_usb_prints(" ", 1);
c0de0d54:	4815      	ldr	r0, [pc, #84]	; (c0de0dac <mcu_usb_printf+0x308>)
c0de0d56:	4478      	add	r0, pc
c0de0d58:	2101      	movs	r1, #1
c0de0d5a:	f7ff fe91 	bl	c0de0a80 <mcu_usb_prints>
                        while(ulCount--)
c0de0d5e:	1c64      	adds	r4, r4, #1
c0de0d60:	e7f5      	b.n	c0de0d4e <mcu_usb_printf+0x2aa>
                        if (idx != 0) {
c0de0d62:	2900      	cmp	r1, #0
c0de0d64:	9f03      	ldr	r7, [sp, #12]
c0de0d66:	d100      	bne.n	c0de0d6a <mcu_usb_printf+0x2c6>
c0de0d68:	e6a9      	b.n	c0de0abe <mcu_usb_printf+0x1a>
c0de0d6a:	a809      	add	r0, sp, #36	; 0x24
                            mcu_usb_prints(pcBuf, idx);
c0de0d6c:	f7ff fe88 	bl	c0de0a80 <mcu_usb_prints>
c0de0d70:	e6a5      	b.n	c0de0abe <mcu_usb_printf+0x1a>
                        ulValue = -(long)ulValue;
c0de0d72:	4240      	negs	r0, r0
c0de0d74:	9005      	str	r0, [sp, #20]
c0de0d76:	900d      	str	r0, [sp, #52]	; 0x34
c0de0d78:	2100      	movs	r1, #0
            ulCap = 0;
c0de0d7a:	9100      	str	r1, [sp, #0]
c0de0d7c:	9f02      	ldr	r7, [sp, #8]
c0de0d7e:	e75b      	b.n	c0de0c38 <mcu_usb_printf+0x194>
                          do {
c0de0d80:	9807      	ldr	r0, [sp, #28]
c0de0d82:	1c44      	adds	r4, r0, #1
                            mcu_usb_prints(" ", 1);
c0de0d84:	4808      	ldr	r0, [pc, #32]	; (c0de0da8 <mcu_usb_printf+0x304>)
c0de0d86:	4478      	add	r0, pc
c0de0d88:	2101      	movs	r1, #1
c0de0d8a:	f7ff fe79 	bl	c0de0a80 <mcu_usb_prints>
                          } while(ulStrlen-- > 0);
c0de0d8e:	1e64      	subs	r4, r4, #1
c0de0d90:	d1f8      	bne.n	c0de0d84 <mcu_usb_printf+0x2e0>
c0de0d92:	e7d6      	b.n	c0de0d42 <mcu_usb_printf+0x29e>

    //
    // End the varargs processing.
    //
    va_end(vaArgP);
}
c0de0d94:	b00e      	add	sp, #56	; 0x38
c0de0d96:	bcf0      	pop	{r4, r5, r6, r7}
c0de0d98:	bc01      	pop	{r0}
c0de0d9a:	b003      	add	sp, #12
c0de0d9c:	4700      	bx	r0
c0de0d9e:	46c0      	nop			; (mov r8, r8)
c0de0da0:	00000eb6 	.word	0x00000eb6
c0de0da4:	00000ea2 	.word	0x00000ea2
c0de0da8:	000009f5 	.word	0x000009f5
c0de0dac:	00000a25 	.word	0x00000a25
c0de0db0:	00000e0a 	.word	0x00000e0a
c0de0db4:	00000d7c 	.word	0x00000d7c
c0de0db8:	00000c4b 	.word	0x00000c4b

c0de0dbc <pic_internal>:
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"
__attribute__((naked,no_instrument_function)) void *pic_internal(void *link_address)
{
  // compute the delta offset between LinkMemAddr & ExecMemAddr
  __asm volatile ("mov r2, pc\n");
c0de0dbc:	467a      	mov	r2, pc
  __asm volatile ("ldr r1, =pic_internal\n");
c0de0dbe:	4902      	ldr	r1, [pc, #8]	; (c0de0dc8 <pic_internal+0xc>)
  __asm volatile ("adds r1, r1, #3\n");
c0de0dc0:	1cc9      	adds	r1, r1, #3
  __asm volatile ("subs r1, r1, r2\n");
c0de0dc2:	1a89      	subs	r1, r1, r2

  // adjust value of the given parameter
  __asm volatile ("subs r0, r0, r1\n");
c0de0dc4:	1a40      	subs	r0, r0, r1
  __asm volatile ("bx lr\n");
c0de0dc6:	4770      	bx	lr
c0de0dc8:	c0de0dbd 	.word	0xc0de0dbd

c0de0dcc <pic>:
#elif defined(ST33) || defined(ST33K1M5)

extern void _bss;
extern void _estack;

void *pic(void *link_address) {
c0de0dcc:	b580      	push	{r7, lr}
  void *n, *en;

  // check if in the LINKED TEXT zone
  __asm volatile("ldr %0, =_nvram":"=r"(n));
c0de0dce:	4a09      	ldr	r2, [pc, #36]	; (c0de0df4 <pic+0x28>)
  __asm volatile("ldr %0, =_envram":"=r"(en));
c0de0dd0:	4909      	ldr	r1, [pc, #36]	; (c0de0df8 <pic+0x2c>)
  if (link_address >= n && link_address <= en) {
c0de0dd2:	4282      	cmp	r2, r0
c0de0dd4:	d803      	bhi.n	c0de0dde <pic+0x12>
c0de0dd6:	4281      	cmp	r1, r0
c0de0dd8:	d301      	bcc.n	c0de0dde <pic+0x12>
    link_address = pic_internal(link_address);
c0de0dda:	f7ff ffef 	bl	c0de0dbc <pic_internal>
  }

  // check if in the LINKED RAM zone
  __asm volatile("ldr %0, =_bss":"=r"(n));
c0de0dde:	4907      	ldr	r1, [pc, #28]	; (c0de0dfc <pic+0x30>)
  __asm volatile("ldr %0, =_estack":"=r"(en));
c0de0de0:	4a07      	ldr	r2, [pc, #28]	; (c0de0e00 <pic+0x34>)
  if (link_address >= n && link_address <= en) {
c0de0de2:	4288      	cmp	r0, r1
c0de0de4:	d304      	bcc.n	c0de0df0 <pic+0x24>
c0de0de6:	4290      	cmp	r0, r2
c0de0de8:	d802      	bhi.n	c0de0df0 <pic+0x24>
    __asm volatile("mov %0, r9":"=r"(en));
    // deref into the RAM therefore add the RAM offset from R9
    link_address = (char *)link_address - (char *)n + (char *)en;
c0de0dea:	1a40      	subs	r0, r0, r1
    __asm volatile("mov %0, r9":"=r"(en));
c0de0dec:	4649      	mov	r1, r9
    link_address = (char *)link_address - (char *)n + (char *)en;
c0de0dee:	1808      	adds	r0, r1, r0
  }

  return link_address;
c0de0df0:	bd80      	pop	{r7, pc}
c0de0df2:	46c0      	nop			; (mov r8, r8)
c0de0df4:	c0de0000 	.word	0xc0de0000
c0de0df8:	c0de1b00 	.word	0xc0de1b00
c0de0dfc:	da7a0000 	.word	0xda7a0000
c0de0e00:	da7a7800 	.word	0xda7a7800

c0de0e04 <SVC_Call>:
.thumb
.thumb_func
.global SVC_Call

SVC_Call:
    svc 1
c0de0e04:	df01      	svc	1
    cmp r1, #0
c0de0e06:	2900      	cmp	r1, #0
    bne exception
c0de0e08:	d100      	bne.n	c0de0e0c <exception>
    bx lr
c0de0e0a:	4770      	bx	lr

c0de0e0c <exception>:
exception:
    // THROW(ex);
    mov r0, r1
c0de0e0c:	4608      	mov	r0, r1
    bl os_longjmp
c0de0e0e:	f7ff fe29 	bl	c0de0a64 <os_longjmp>

c0de0e12 <get_api_level>:
#include <string.h>

unsigned int SVC_Call(unsigned int syscall_id, void *parameters);
unsigned int SVC_cx_call(unsigned int syscall_id, unsigned int * parameters);

unsigned int get_api_level(void) {
c0de0e12:	b5e0      	push	{r5, r6, r7, lr}
c0de0e14:	2000      	movs	r0, #0
  unsigned int parameters[2];
  parameters[0] = 0;
  parameters[1] = 0;
c0de0e16:	9001      	str	r0, [sp, #4]
  parameters[0] = 0;
c0de0e18:	9000      	str	r0, [sp, #0]
c0de0e1a:	2001      	movs	r0, #1
c0de0e1c:	4669      	mov	r1, sp
  return SVC_Call(SYSCALL_get_api_level_ID, parameters);
c0de0e1e:	f7ff fff1 	bl	c0de0e04 <SVC_Call>
c0de0e22:	bd8c      	pop	{r2, r3, r7, pc}

c0de0e24 <os_lib_call>:
  SVC_Call(SYSCALL_os_ux_result_ID, parameters);
  return;
}
#endif // !defined(APP_UX)

void os_lib_call ( unsigned int * call_parameters ) {
c0de0e24:	b5e0      	push	{r5, r6, r7, lr}
c0de0e26:	2100      	movs	r1, #0
  unsigned int parameters[2];
  parameters[0] = (unsigned int)call_parameters;
  parameters[1] = 0;
c0de0e28:	9101      	str	r1, [sp, #4]
  parameters[0] = (unsigned int)call_parameters;
c0de0e2a:	9000      	str	r0, [sp, #0]
c0de0e2c:	4802      	ldr	r0, [pc, #8]	; (c0de0e38 <os_lib_call+0x14>)
c0de0e2e:	4669      	mov	r1, sp
  SVC_Call(SYSCALL_os_lib_call_ID, parameters);
c0de0e30:	f7ff ffe8 	bl	c0de0e04 <SVC_Call>
  return;
}
c0de0e34:	bd8c      	pop	{r2, r3, r7, pc}
c0de0e36:	46c0      	nop			; (mov r8, r8)
c0de0e38:	01000067 	.word	0x01000067

c0de0e3c <os_lib_end>:

void __attribute__((noreturn)) os_lib_end ( void ) {
c0de0e3c:	b082      	sub	sp, #8
c0de0e3e:	2000      	movs	r0, #0
  unsigned int parameters[2];
  parameters[1] = 0;
c0de0e40:	9001      	str	r0, [sp, #4]
c0de0e42:	2068      	movs	r0, #104	; 0x68
c0de0e44:	4669      	mov	r1, sp
  SVC_Call(SYSCALL_os_lib_end_ID, parameters);
c0de0e46:	f7ff ffdd 	bl	c0de0e04 <SVC_Call>

  // The os_lib_end syscall should never return.
  // Just in case, crash the device thanks to an undefined instruction.
  // To avoid the __builtin_unreachable undefined behaviour
  asm volatile ("udf #255");
c0de0e4a:	deff      	udf	#255	; 0xff

c0de0e4c <os_sched_exit>:
  parameters[1] = 0;
  SVC_Call(SYSCALL_os_sched_exec_ID, parameters);
  return;
}

void __attribute__((noreturn)) os_sched_exit ( bolos_task_status_t exit_code ) {
c0de0e4c:	b082      	sub	sp, #8
c0de0e4e:	2100      	movs	r1, #0
  unsigned int parameters[2];
  parameters[0] = (unsigned int)exit_code;
  parameters[1] = 0;
c0de0e50:	9101      	str	r1, [sp, #4]
  parameters[0] = (unsigned int)exit_code;
c0de0e52:	9000      	str	r0, [sp, #0]
c0de0e54:	4802      	ldr	r0, [pc, #8]	; (c0de0e60 <os_sched_exit+0x14>)
c0de0e56:	4669      	mov	r1, sp
  SVC_Call(SYSCALL_os_sched_exit_ID, parameters);
c0de0e58:	f7ff ffd4 	bl	c0de0e04 <SVC_Call>

  // The os_sched_exit syscall should never return.
  // Just in case, crash the device thanks to an undefined instruction.
  // To avoid the __builtin_unreachable undefined behaviour
  asm volatile ("udf #255");
c0de0e5c:	deff      	udf	#255	; 0xff
c0de0e5e:	46c0      	nop			; (mov r8, r8)
c0de0e60:	0100009a 	.word	0x0100009a

c0de0e64 <io_seph_send>:
  parameters[1] = 0;
  SVC_Call(SYSCALL_os_sched_kill_ID, parameters);
  return;
}

void io_seph_send ( const unsigned char * buffer, unsigned short length ) {
c0de0e64:	b5e0      	push	{r5, r6, r7, lr}
  unsigned int parameters[2];
  parameters[0] = (unsigned int)buffer;
  parameters[1] = (unsigned int)length;
c0de0e66:	9101      	str	r1, [sp, #4]
  parameters[0] = (unsigned int)buffer;
c0de0e68:	9000      	str	r0, [sp, #0]
c0de0e6a:	4802      	ldr	r0, [pc, #8]	; (c0de0e74 <io_seph_send+0x10>)
c0de0e6c:	4669      	mov	r1, sp
  SVC_Call(SYSCALL_io_seph_send_ID, parameters);
c0de0e6e:	f7ff ffc9 	bl	c0de0e04 <SVC_Call>
  return;
}
c0de0e72:	bd8c      	pop	{r2, r3, r7, pc}
c0de0e74:	02000083 	.word	0x02000083

c0de0e78 <try_context_get>:
  parameters[1] = 0;
  SVC_Call(SYSCALL_nvm_erase_page_ID, parameters);
  return;
}

try_context_t * try_context_get ( void ) {
c0de0e78:	b5e0      	push	{r5, r6, r7, lr}
c0de0e7a:	2000      	movs	r0, #0
  unsigned int parameters[2];
  parameters[1] = 0;
c0de0e7c:	9001      	str	r0, [sp, #4]
c0de0e7e:	2087      	movs	r0, #135	; 0x87
c0de0e80:	4669      	mov	r1, sp
  return (try_context_t *) SVC_Call(SYSCALL_try_context_get_ID, parameters);
c0de0e82:	f7ff ffbf 	bl	c0de0e04 <SVC_Call>
c0de0e86:	bd8c      	pop	{r2, r3, r7, pc}

c0de0e88 <try_context_set>:
}

try_context_t * try_context_set ( try_context_t *context ) {
c0de0e88:	b5e0      	push	{r5, r6, r7, lr}
c0de0e8a:	2100      	movs	r1, #0
  unsigned int parameters[2];
  parameters[0] = (unsigned int)context;
  parameters[1] = 0;
c0de0e8c:	9101      	str	r1, [sp, #4]
  parameters[0] = (unsigned int)context;
c0de0e8e:	9000      	str	r0, [sp, #0]
c0de0e90:	4802      	ldr	r0, [pc, #8]	; (c0de0e9c <try_context_set+0x14>)
c0de0e92:	4669      	mov	r1, sp
  return (try_context_t *) SVC_Call(SYSCALL_try_context_set_ID, parameters);
c0de0e94:	f7ff ffb6 	bl	c0de0e04 <SVC_Call>
c0de0e98:	bd8c      	pop	{r2, r3, r7, pc}
c0de0e9a:	46c0      	nop			; (mov r8, r8)
c0de0e9c:	0100010b 	.word	0x0100010b

c0de0ea0 <__udivsi3>:
c0de0ea0:	2200      	movs	r2, #0
c0de0ea2:	0843      	lsrs	r3, r0, #1
c0de0ea4:	428b      	cmp	r3, r1
c0de0ea6:	d374      	bcc.n	c0de0f92 <__udivsi3+0xf2>
c0de0ea8:	0903      	lsrs	r3, r0, #4
c0de0eaa:	428b      	cmp	r3, r1
c0de0eac:	d35f      	bcc.n	c0de0f6e <__udivsi3+0xce>
c0de0eae:	0a03      	lsrs	r3, r0, #8
c0de0eb0:	428b      	cmp	r3, r1
c0de0eb2:	d344      	bcc.n	c0de0f3e <__udivsi3+0x9e>
c0de0eb4:	0b03      	lsrs	r3, r0, #12
c0de0eb6:	428b      	cmp	r3, r1
c0de0eb8:	d328      	bcc.n	c0de0f0c <__udivsi3+0x6c>
c0de0eba:	0c03      	lsrs	r3, r0, #16
c0de0ebc:	428b      	cmp	r3, r1
c0de0ebe:	d30d      	bcc.n	c0de0edc <__udivsi3+0x3c>
c0de0ec0:	22ff      	movs	r2, #255	; 0xff
c0de0ec2:	0209      	lsls	r1, r1, #8
c0de0ec4:	ba12      	rev	r2, r2
c0de0ec6:	0c03      	lsrs	r3, r0, #16
c0de0ec8:	428b      	cmp	r3, r1
c0de0eca:	d302      	bcc.n	c0de0ed2 <__udivsi3+0x32>
c0de0ecc:	1212      	asrs	r2, r2, #8
c0de0ece:	0209      	lsls	r1, r1, #8
c0de0ed0:	d065      	beq.n	c0de0f9e <__udivsi3+0xfe>
c0de0ed2:	0b03      	lsrs	r3, r0, #12
c0de0ed4:	428b      	cmp	r3, r1
c0de0ed6:	d319      	bcc.n	c0de0f0c <__udivsi3+0x6c>
c0de0ed8:	e000      	b.n	c0de0edc <__udivsi3+0x3c>
c0de0eda:	0a09      	lsrs	r1, r1, #8
c0de0edc:	0bc3      	lsrs	r3, r0, #15
c0de0ede:	428b      	cmp	r3, r1
c0de0ee0:	d301      	bcc.n	c0de0ee6 <__udivsi3+0x46>
c0de0ee2:	03cb      	lsls	r3, r1, #15
c0de0ee4:	1ac0      	subs	r0, r0, r3
c0de0ee6:	4152      	adcs	r2, r2
c0de0ee8:	0b83      	lsrs	r3, r0, #14
c0de0eea:	428b      	cmp	r3, r1
c0de0eec:	d301      	bcc.n	c0de0ef2 <__udivsi3+0x52>
c0de0eee:	038b      	lsls	r3, r1, #14
c0de0ef0:	1ac0      	subs	r0, r0, r3
c0de0ef2:	4152      	adcs	r2, r2
c0de0ef4:	0b43      	lsrs	r3, r0, #13
c0de0ef6:	428b      	cmp	r3, r1
c0de0ef8:	d301      	bcc.n	c0de0efe <__udivsi3+0x5e>
c0de0efa:	034b      	lsls	r3, r1, #13
c0de0efc:	1ac0      	subs	r0, r0, r3
c0de0efe:	4152      	adcs	r2, r2
c0de0f00:	0b03      	lsrs	r3, r0, #12
c0de0f02:	428b      	cmp	r3, r1
c0de0f04:	d301      	bcc.n	c0de0f0a <__udivsi3+0x6a>
c0de0f06:	030b      	lsls	r3, r1, #12
c0de0f08:	1ac0      	subs	r0, r0, r3
c0de0f0a:	4152      	adcs	r2, r2
c0de0f0c:	0ac3      	lsrs	r3, r0, #11
c0de0f0e:	428b      	cmp	r3, r1
c0de0f10:	d301      	bcc.n	c0de0f16 <__udivsi3+0x76>
c0de0f12:	02cb      	lsls	r3, r1, #11
c0de0f14:	1ac0      	subs	r0, r0, r3
c0de0f16:	4152      	adcs	r2, r2
c0de0f18:	0a83      	lsrs	r3, r0, #10
c0de0f1a:	428b      	cmp	r3, r1
c0de0f1c:	d301      	bcc.n	c0de0f22 <__udivsi3+0x82>
c0de0f1e:	028b      	lsls	r3, r1, #10
c0de0f20:	1ac0      	subs	r0, r0, r3
c0de0f22:	4152      	adcs	r2, r2
c0de0f24:	0a43      	lsrs	r3, r0, #9
c0de0f26:	428b      	cmp	r3, r1
c0de0f28:	d301      	bcc.n	c0de0f2e <__udivsi3+0x8e>
c0de0f2a:	024b      	lsls	r3, r1, #9
c0de0f2c:	1ac0      	subs	r0, r0, r3
c0de0f2e:	4152      	adcs	r2, r2
c0de0f30:	0a03      	lsrs	r3, r0, #8
c0de0f32:	428b      	cmp	r3, r1
c0de0f34:	d301      	bcc.n	c0de0f3a <__udivsi3+0x9a>
c0de0f36:	020b      	lsls	r3, r1, #8
c0de0f38:	1ac0      	subs	r0, r0, r3
c0de0f3a:	4152      	adcs	r2, r2
c0de0f3c:	d2cd      	bcs.n	c0de0eda <__udivsi3+0x3a>
c0de0f3e:	09c3      	lsrs	r3, r0, #7
c0de0f40:	428b      	cmp	r3, r1
c0de0f42:	d301      	bcc.n	c0de0f48 <__udivsi3+0xa8>
c0de0f44:	01cb      	lsls	r3, r1, #7
c0de0f46:	1ac0      	subs	r0, r0, r3
c0de0f48:	4152      	adcs	r2, r2
c0de0f4a:	0983      	lsrs	r3, r0, #6
c0de0f4c:	428b      	cmp	r3, r1
c0de0f4e:	d301      	bcc.n	c0de0f54 <__udivsi3+0xb4>
c0de0f50:	018b      	lsls	r3, r1, #6
c0de0f52:	1ac0      	subs	r0, r0, r3
c0de0f54:	4152      	adcs	r2, r2
c0de0f56:	0943      	lsrs	r3, r0, #5
c0de0f58:	428b      	cmp	r3, r1
c0de0f5a:	d301      	bcc.n	c0de0f60 <__udivsi3+0xc0>
c0de0f5c:	014b      	lsls	r3, r1, #5
c0de0f5e:	1ac0      	subs	r0, r0, r3
c0de0f60:	4152      	adcs	r2, r2
c0de0f62:	0903      	lsrs	r3, r0, #4
c0de0f64:	428b      	cmp	r3, r1
c0de0f66:	d301      	bcc.n	c0de0f6c <__udivsi3+0xcc>
c0de0f68:	010b      	lsls	r3, r1, #4
c0de0f6a:	1ac0      	subs	r0, r0, r3
c0de0f6c:	4152      	adcs	r2, r2
c0de0f6e:	08c3      	lsrs	r3, r0, #3
c0de0f70:	428b      	cmp	r3, r1
c0de0f72:	d301      	bcc.n	c0de0f78 <__udivsi3+0xd8>
c0de0f74:	00cb      	lsls	r3, r1, #3
c0de0f76:	1ac0      	subs	r0, r0, r3
c0de0f78:	4152      	adcs	r2, r2
c0de0f7a:	0883      	lsrs	r3, r0, #2
c0de0f7c:	428b      	cmp	r3, r1
c0de0f7e:	d301      	bcc.n	c0de0f84 <__udivsi3+0xe4>
c0de0f80:	008b      	lsls	r3, r1, #2
c0de0f82:	1ac0      	subs	r0, r0, r3
c0de0f84:	4152      	adcs	r2, r2
c0de0f86:	0843      	lsrs	r3, r0, #1
c0de0f88:	428b      	cmp	r3, r1
c0de0f8a:	d301      	bcc.n	c0de0f90 <__udivsi3+0xf0>
c0de0f8c:	004b      	lsls	r3, r1, #1
c0de0f8e:	1ac0      	subs	r0, r0, r3
c0de0f90:	4152      	adcs	r2, r2
c0de0f92:	1a41      	subs	r1, r0, r1
c0de0f94:	d200      	bcs.n	c0de0f98 <__udivsi3+0xf8>
c0de0f96:	4601      	mov	r1, r0
c0de0f98:	4152      	adcs	r2, r2
c0de0f9a:	4610      	mov	r0, r2
c0de0f9c:	4770      	bx	lr
c0de0f9e:	e7ff      	b.n	c0de0fa0 <__udivsi3+0x100>
c0de0fa0:	b501      	push	{r0, lr}
c0de0fa2:	2000      	movs	r0, #0
c0de0fa4:	f000 f806 	bl	c0de0fb4 <__aeabi_idiv0>
c0de0fa8:	bd02      	pop	{r1, pc}
c0de0faa:	46c0      	nop			; (mov r8, r8)

c0de0fac <__aeabi_uidivmod>:
c0de0fac:	2900      	cmp	r1, #0
c0de0fae:	d0f7      	beq.n	c0de0fa0 <__udivsi3+0x100>
c0de0fb0:	e776      	b.n	c0de0ea0 <__udivsi3>
c0de0fb2:	4770      	bx	lr

c0de0fb4 <__aeabi_idiv0>:
c0de0fb4:	4770      	bx	lr
c0de0fb6:	46c0      	nop			; (mov r8, r8)

c0de0fb8 <__aeabi_uldivmod>:
c0de0fb8:	2b00      	cmp	r3, #0
c0de0fba:	d111      	bne.n	c0de0fe0 <__aeabi_uldivmod+0x28>
c0de0fbc:	2a00      	cmp	r2, #0
c0de0fbe:	d10f      	bne.n	c0de0fe0 <__aeabi_uldivmod+0x28>
c0de0fc0:	2900      	cmp	r1, #0
c0de0fc2:	d100      	bne.n	c0de0fc6 <__aeabi_uldivmod+0xe>
c0de0fc4:	2800      	cmp	r0, #0
c0de0fc6:	d002      	beq.n	c0de0fce <__aeabi_uldivmod+0x16>
c0de0fc8:	2100      	movs	r1, #0
c0de0fca:	43c9      	mvns	r1, r1
c0de0fcc:	1c08      	adds	r0, r1, #0
c0de0fce:	b407      	push	{r0, r1, r2}
c0de0fd0:	4802      	ldr	r0, [pc, #8]	; (c0de0fdc <__aeabi_uldivmod+0x24>)
c0de0fd2:	a102      	add	r1, pc, #8	; (adr r1, c0de0fdc <__aeabi_uldivmod+0x24>)
c0de0fd4:	1840      	adds	r0, r0, r1
c0de0fd6:	9002      	str	r0, [sp, #8]
c0de0fd8:	bd03      	pop	{r0, r1, pc}
c0de0fda:	46c0      	nop			; (mov r8, r8)
c0de0fdc:	ffffffd9 	.word	0xffffffd9
c0de0fe0:	b403      	push	{r0, r1}
c0de0fe2:	4668      	mov	r0, sp
c0de0fe4:	b501      	push	{r0, lr}
c0de0fe6:	9802      	ldr	r0, [sp, #8]
c0de0fe8:	f000 f830 	bl	c0de104c <__udivmoddi4>
c0de0fec:	9b01      	ldr	r3, [sp, #4]
c0de0fee:	469e      	mov	lr, r3
c0de0ff0:	b002      	add	sp, #8
c0de0ff2:	bc0c      	pop	{r2, r3}
c0de0ff4:	4770      	bx	lr
c0de0ff6:	46c0      	nop			; (mov r8, r8)

c0de0ff8 <__aeabi_lmul>:
c0de0ff8:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de0ffa:	46ce      	mov	lr, r9
c0de0ffc:	4647      	mov	r7, r8
c0de0ffe:	0415      	lsls	r5, r2, #16
c0de1000:	0c2d      	lsrs	r5, r5, #16
c0de1002:	002e      	movs	r6, r5
c0de1004:	b580      	push	{r7, lr}
c0de1006:	0407      	lsls	r7, r0, #16
c0de1008:	0c14      	lsrs	r4, r2, #16
c0de100a:	0c3f      	lsrs	r7, r7, #16
c0de100c:	4699      	mov	r9, r3
c0de100e:	0c03      	lsrs	r3, r0, #16
c0de1010:	437e      	muls	r6, r7
c0de1012:	435d      	muls	r5, r3
c0de1014:	4367      	muls	r7, r4
c0de1016:	4363      	muls	r3, r4
c0de1018:	197f      	adds	r7, r7, r5
c0de101a:	0c34      	lsrs	r4, r6, #16
c0de101c:	19e4      	adds	r4, r4, r7
c0de101e:	469c      	mov	ip, r3
c0de1020:	42a5      	cmp	r5, r4
c0de1022:	d903      	bls.n	c0de102c <__aeabi_lmul+0x34>
c0de1024:	2380      	movs	r3, #128	; 0x80
c0de1026:	025b      	lsls	r3, r3, #9
c0de1028:	4698      	mov	r8, r3
c0de102a:	44c4      	add	ip, r8
c0de102c:	464b      	mov	r3, r9
c0de102e:	4343      	muls	r3, r0
c0de1030:	4351      	muls	r1, r2
c0de1032:	0c25      	lsrs	r5, r4, #16
c0de1034:	0436      	lsls	r6, r6, #16
c0de1036:	4465      	add	r5, ip
c0de1038:	0c36      	lsrs	r6, r6, #16
c0de103a:	0424      	lsls	r4, r4, #16
c0de103c:	19a4      	adds	r4, r4, r6
c0de103e:	195b      	adds	r3, r3, r5
c0de1040:	1859      	adds	r1, r3, r1
c0de1042:	0020      	movs	r0, r4
c0de1044:	bc0c      	pop	{r2, r3}
c0de1046:	4690      	mov	r8, r2
c0de1048:	4699      	mov	r9, r3
c0de104a:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0de104c <__udivmoddi4>:
c0de104c:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de104e:	4657      	mov	r7, sl
c0de1050:	464e      	mov	r6, r9
c0de1052:	4645      	mov	r5, r8
c0de1054:	46de      	mov	lr, fp
c0de1056:	b5e0      	push	{r5, r6, r7, lr}
c0de1058:	0004      	movs	r4, r0
c0de105a:	b083      	sub	sp, #12
c0de105c:	000d      	movs	r5, r1
c0de105e:	4692      	mov	sl, r2
c0de1060:	4699      	mov	r9, r3
c0de1062:	428b      	cmp	r3, r1
c0de1064:	d830      	bhi.n	c0de10c8 <__udivmoddi4+0x7c>
c0de1066:	d02d      	beq.n	c0de10c4 <__udivmoddi4+0x78>
c0de1068:	4649      	mov	r1, r9
c0de106a:	4650      	mov	r0, sl
c0de106c:	f000 f8c0 	bl	c0de11f0 <__clzdi2>
c0de1070:	0029      	movs	r1, r5
c0de1072:	0006      	movs	r6, r0
c0de1074:	0020      	movs	r0, r4
c0de1076:	f000 f8bb 	bl	c0de11f0 <__clzdi2>
c0de107a:	1a33      	subs	r3, r6, r0
c0de107c:	4698      	mov	r8, r3
c0de107e:	3b20      	subs	r3, #32
c0de1080:	469b      	mov	fp, r3
c0de1082:	d433      	bmi.n	c0de10ec <__udivmoddi4+0xa0>
c0de1084:	465a      	mov	r2, fp
c0de1086:	4653      	mov	r3, sl
c0de1088:	4093      	lsls	r3, r2
c0de108a:	4642      	mov	r2, r8
c0de108c:	001f      	movs	r7, r3
c0de108e:	4653      	mov	r3, sl
c0de1090:	4093      	lsls	r3, r2
c0de1092:	001e      	movs	r6, r3
c0de1094:	42af      	cmp	r7, r5
c0de1096:	d83a      	bhi.n	c0de110e <__udivmoddi4+0xc2>
c0de1098:	42af      	cmp	r7, r5
c0de109a:	d100      	bne.n	c0de109e <__udivmoddi4+0x52>
c0de109c:	e07b      	b.n	c0de1196 <__udivmoddi4+0x14a>
c0de109e:	465b      	mov	r3, fp
c0de10a0:	1ba4      	subs	r4, r4, r6
c0de10a2:	41bd      	sbcs	r5, r7
c0de10a4:	2b00      	cmp	r3, #0
c0de10a6:	da00      	bge.n	c0de10aa <__udivmoddi4+0x5e>
c0de10a8:	e078      	b.n	c0de119c <__udivmoddi4+0x150>
c0de10aa:	2200      	movs	r2, #0
c0de10ac:	2300      	movs	r3, #0
c0de10ae:	9200      	str	r2, [sp, #0]
c0de10b0:	9301      	str	r3, [sp, #4]
c0de10b2:	2301      	movs	r3, #1
c0de10b4:	465a      	mov	r2, fp
c0de10b6:	4093      	lsls	r3, r2
c0de10b8:	9301      	str	r3, [sp, #4]
c0de10ba:	2301      	movs	r3, #1
c0de10bc:	4642      	mov	r2, r8
c0de10be:	4093      	lsls	r3, r2
c0de10c0:	9300      	str	r3, [sp, #0]
c0de10c2:	e028      	b.n	c0de1116 <__udivmoddi4+0xca>
c0de10c4:	4282      	cmp	r2, r0
c0de10c6:	d9cf      	bls.n	c0de1068 <__udivmoddi4+0x1c>
c0de10c8:	2200      	movs	r2, #0
c0de10ca:	2300      	movs	r3, #0
c0de10cc:	9200      	str	r2, [sp, #0]
c0de10ce:	9301      	str	r3, [sp, #4]
c0de10d0:	9b0c      	ldr	r3, [sp, #48]	; 0x30
c0de10d2:	2b00      	cmp	r3, #0
c0de10d4:	d001      	beq.n	c0de10da <__udivmoddi4+0x8e>
c0de10d6:	601c      	str	r4, [r3, #0]
c0de10d8:	605d      	str	r5, [r3, #4]
c0de10da:	9800      	ldr	r0, [sp, #0]
c0de10dc:	9901      	ldr	r1, [sp, #4]
c0de10de:	b003      	add	sp, #12
c0de10e0:	bc3c      	pop	{r2, r3, r4, r5}
c0de10e2:	4690      	mov	r8, r2
c0de10e4:	4699      	mov	r9, r3
c0de10e6:	46a2      	mov	sl, r4
c0de10e8:	46ab      	mov	fp, r5
c0de10ea:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0de10ec:	4642      	mov	r2, r8
c0de10ee:	2320      	movs	r3, #32
c0de10f0:	1a9b      	subs	r3, r3, r2
c0de10f2:	4652      	mov	r2, sl
c0de10f4:	40da      	lsrs	r2, r3
c0de10f6:	4641      	mov	r1, r8
c0de10f8:	0013      	movs	r3, r2
c0de10fa:	464a      	mov	r2, r9
c0de10fc:	408a      	lsls	r2, r1
c0de10fe:	0017      	movs	r7, r2
c0de1100:	4642      	mov	r2, r8
c0de1102:	431f      	orrs	r7, r3
c0de1104:	4653      	mov	r3, sl
c0de1106:	4093      	lsls	r3, r2
c0de1108:	001e      	movs	r6, r3
c0de110a:	42af      	cmp	r7, r5
c0de110c:	d9c4      	bls.n	c0de1098 <__udivmoddi4+0x4c>
c0de110e:	2200      	movs	r2, #0
c0de1110:	2300      	movs	r3, #0
c0de1112:	9200      	str	r2, [sp, #0]
c0de1114:	9301      	str	r3, [sp, #4]
c0de1116:	4643      	mov	r3, r8
c0de1118:	2b00      	cmp	r3, #0
c0de111a:	d0d9      	beq.n	c0de10d0 <__udivmoddi4+0x84>
c0de111c:	07fb      	lsls	r3, r7, #31
c0de111e:	469c      	mov	ip, r3
c0de1120:	4661      	mov	r1, ip
c0de1122:	0872      	lsrs	r2, r6, #1
c0de1124:	430a      	orrs	r2, r1
c0de1126:	087b      	lsrs	r3, r7, #1
c0de1128:	4646      	mov	r6, r8
c0de112a:	e00e      	b.n	c0de114a <__udivmoddi4+0xfe>
c0de112c:	42ab      	cmp	r3, r5
c0de112e:	d101      	bne.n	c0de1134 <__udivmoddi4+0xe8>
c0de1130:	42a2      	cmp	r2, r4
c0de1132:	d80c      	bhi.n	c0de114e <__udivmoddi4+0x102>
c0de1134:	1aa4      	subs	r4, r4, r2
c0de1136:	419d      	sbcs	r5, r3
c0de1138:	2001      	movs	r0, #1
c0de113a:	1924      	adds	r4, r4, r4
c0de113c:	416d      	adcs	r5, r5
c0de113e:	2100      	movs	r1, #0
c0de1140:	3e01      	subs	r6, #1
c0de1142:	1824      	adds	r4, r4, r0
c0de1144:	414d      	adcs	r5, r1
c0de1146:	2e00      	cmp	r6, #0
c0de1148:	d006      	beq.n	c0de1158 <__udivmoddi4+0x10c>
c0de114a:	42ab      	cmp	r3, r5
c0de114c:	d9ee      	bls.n	c0de112c <__udivmoddi4+0xe0>
c0de114e:	3e01      	subs	r6, #1
c0de1150:	1924      	adds	r4, r4, r4
c0de1152:	416d      	adcs	r5, r5
c0de1154:	2e00      	cmp	r6, #0
c0de1156:	d1f8      	bne.n	c0de114a <__udivmoddi4+0xfe>
c0de1158:	9800      	ldr	r0, [sp, #0]
c0de115a:	9901      	ldr	r1, [sp, #4]
c0de115c:	465b      	mov	r3, fp
c0de115e:	1900      	adds	r0, r0, r4
c0de1160:	4169      	adcs	r1, r5
c0de1162:	2b00      	cmp	r3, #0
c0de1164:	db25      	blt.n	c0de11b2 <__udivmoddi4+0x166>
c0de1166:	002b      	movs	r3, r5
c0de1168:	465a      	mov	r2, fp
c0de116a:	4644      	mov	r4, r8
c0de116c:	40d3      	lsrs	r3, r2
c0de116e:	002a      	movs	r2, r5
c0de1170:	40e2      	lsrs	r2, r4
c0de1172:	001c      	movs	r4, r3
c0de1174:	465b      	mov	r3, fp
c0de1176:	0015      	movs	r5, r2
c0de1178:	2b00      	cmp	r3, #0
c0de117a:	db2b      	blt.n	c0de11d4 <__udivmoddi4+0x188>
c0de117c:	0026      	movs	r6, r4
c0de117e:	465f      	mov	r7, fp
c0de1180:	40be      	lsls	r6, r7
c0de1182:	0033      	movs	r3, r6
c0de1184:	0026      	movs	r6, r4
c0de1186:	4647      	mov	r7, r8
c0de1188:	40be      	lsls	r6, r7
c0de118a:	0032      	movs	r2, r6
c0de118c:	1a80      	subs	r0, r0, r2
c0de118e:	4199      	sbcs	r1, r3
c0de1190:	9000      	str	r0, [sp, #0]
c0de1192:	9101      	str	r1, [sp, #4]
c0de1194:	e79c      	b.n	c0de10d0 <__udivmoddi4+0x84>
c0de1196:	42a3      	cmp	r3, r4
c0de1198:	d8b9      	bhi.n	c0de110e <__udivmoddi4+0xc2>
c0de119a:	e780      	b.n	c0de109e <__udivmoddi4+0x52>
c0de119c:	4642      	mov	r2, r8
c0de119e:	2320      	movs	r3, #32
c0de11a0:	2100      	movs	r1, #0
c0de11a2:	1a9b      	subs	r3, r3, r2
c0de11a4:	2200      	movs	r2, #0
c0de11a6:	9100      	str	r1, [sp, #0]
c0de11a8:	9201      	str	r2, [sp, #4]
c0de11aa:	2201      	movs	r2, #1
c0de11ac:	40da      	lsrs	r2, r3
c0de11ae:	9201      	str	r2, [sp, #4]
c0de11b0:	e783      	b.n	c0de10ba <__udivmoddi4+0x6e>
c0de11b2:	4642      	mov	r2, r8
c0de11b4:	2320      	movs	r3, #32
c0de11b6:	1a9b      	subs	r3, r3, r2
c0de11b8:	002a      	movs	r2, r5
c0de11ba:	4646      	mov	r6, r8
c0de11bc:	409a      	lsls	r2, r3
c0de11be:	0023      	movs	r3, r4
c0de11c0:	40f3      	lsrs	r3, r6
c0de11c2:	4644      	mov	r4, r8
c0de11c4:	4313      	orrs	r3, r2
c0de11c6:	002a      	movs	r2, r5
c0de11c8:	40e2      	lsrs	r2, r4
c0de11ca:	001c      	movs	r4, r3
c0de11cc:	465b      	mov	r3, fp
c0de11ce:	0015      	movs	r5, r2
c0de11d0:	2b00      	cmp	r3, #0
c0de11d2:	dad3      	bge.n	c0de117c <__udivmoddi4+0x130>
c0de11d4:	2320      	movs	r3, #32
c0de11d6:	4642      	mov	r2, r8
c0de11d8:	0026      	movs	r6, r4
c0de11da:	1a9b      	subs	r3, r3, r2
c0de11dc:	40de      	lsrs	r6, r3
c0de11de:	002f      	movs	r7, r5
c0de11e0:	46b4      	mov	ip, r6
c0de11e2:	4646      	mov	r6, r8
c0de11e4:	40b7      	lsls	r7, r6
c0de11e6:	4666      	mov	r6, ip
c0de11e8:	003b      	movs	r3, r7
c0de11ea:	4333      	orrs	r3, r6
c0de11ec:	e7ca      	b.n	c0de1184 <__udivmoddi4+0x138>
c0de11ee:	46c0      	nop			; (mov r8, r8)

c0de11f0 <__clzdi2>:
c0de11f0:	b510      	push	{r4, lr}
c0de11f2:	2900      	cmp	r1, #0
c0de11f4:	d103      	bne.n	c0de11fe <__clzdi2+0xe>
c0de11f6:	f000 f807 	bl	c0de1208 <__clzsi2>
c0de11fa:	3020      	adds	r0, #32
c0de11fc:	e002      	b.n	c0de1204 <__clzdi2+0x14>
c0de11fe:	1c08      	adds	r0, r1, #0
c0de1200:	f000 f802 	bl	c0de1208 <__clzsi2>
c0de1204:	bd10      	pop	{r4, pc}
c0de1206:	46c0      	nop			; (mov r8, r8)

c0de1208 <__clzsi2>:
c0de1208:	211c      	movs	r1, #28
c0de120a:	2301      	movs	r3, #1
c0de120c:	041b      	lsls	r3, r3, #16
c0de120e:	4298      	cmp	r0, r3
c0de1210:	d301      	bcc.n	c0de1216 <__clzsi2+0xe>
c0de1212:	0c00      	lsrs	r0, r0, #16
c0de1214:	3910      	subs	r1, #16
c0de1216:	0a1b      	lsrs	r3, r3, #8
c0de1218:	4298      	cmp	r0, r3
c0de121a:	d301      	bcc.n	c0de1220 <__clzsi2+0x18>
c0de121c:	0a00      	lsrs	r0, r0, #8
c0de121e:	3908      	subs	r1, #8
c0de1220:	091b      	lsrs	r3, r3, #4
c0de1222:	4298      	cmp	r0, r3
c0de1224:	d301      	bcc.n	c0de122a <__clzsi2+0x22>
c0de1226:	0900      	lsrs	r0, r0, #4
c0de1228:	3904      	subs	r1, #4
c0de122a:	a202      	add	r2, pc, #8	; (adr r2, c0de1234 <__clzsi2+0x2c>)
c0de122c:	5c10      	ldrb	r0, [r2, r0]
c0de122e:	1840      	adds	r0, r0, r1
c0de1230:	4770      	bx	lr
c0de1232:	46c0      	nop			; (mov r8, r8)
c0de1234:	02020304 	.word	0x02020304
c0de1238:	01010101 	.word	0x01010101
	...

c0de1244 <__aeabi_memclr>:
c0de1244:	b510      	push	{r4, lr}
c0de1246:	2200      	movs	r2, #0
c0de1248:	f000 f80a 	bl	c0de1260 <__aeabi_memset>
c0de124c:	bd10      	pop	{r4, pc}
c0de124e:	46c0      	nop			; (mov r8, r8)

c0de1250 <__aeabi_memcpy>:
c0de1250:	b510      	push	{r4, lr}
c0de1252:	f000 f835 	bl	c0de12c0 <memcpy>
c0de1256:	bd10      	pop	{r4, pc}

c0de1258 <__aeabi_memmove>:
c0de1258:	b510      	push	{r4, lr}
c0de125a:	f000 f885 	bl	c0de1368 <memmove>
c0de125e:	bd10      	pop	{r4, pc}

c0de1260 <__aeabi_memset>:
c0de1260:	0013      	movs	r3, r2
c0de1262:	b510      	push	{r4, lr}
c0de1264:	000a      	movs	r2, r1
c0de1266:	0019      	movs	r1, r3
c0de1268:	f000 f8dc 	bl	c0de1424 <memset>
c0de126c:	bd10      	pop	{r4, pc}
c0de126e:	46c0      	nop			; (mov r8, r8)

c0de1270 <memcmp>:
c0de1270:	b530      	push	{r4, r5, lr}
c0de1272:	2a03      	cmp	r2, #3
c0de1274:	d90c      	bls.n	c0de1290 <memcmp+0x20>
c0de1276:	0003      	movs	r3, r0
c0de1278:	430b      	orrs	r3, r1
c0de127a:	079b      	lsls	r3, r3, #30
c0de127c:	d11c      	bne.n	c0de12b8 <memcmp+0x48>
c0de127e:	6803      	ldr	r3, [r0, #0]
c0de1280:	680c      	ldr	r4, [r1, #0]
c0de1282:	42a3      	cmp	r3, r4
c0de1284:	d118      	bne.n	c0de12b8 <memcmp+0x48>
c0de1286:	3a04      	subs	r2, #4
c0de1288:	3004      	adds	r0, #4
c0de128a:	3104      	adds	r1, #4
c0de128c:	2a03      	cmp	r2, #3
c0de128e:	d8f6      	bhi.n	c0de127e <memcmp+0xe>
c0de1290:	1e55      	subs	r5, r2, #1
c0de1292:	2a00      	cmp	r2, #0
c0de1294:	d00e      	beq.n	c0de12b4 <memcmp+0x44>
c0de1296:	7802      	ldrb	r2, [r0, #0]
c0de1298:	780c      	ldrb	r4, [r1, #0]
c0de129a:	4294      	cmp	r4, r2
c0de129c:	d10e      	bne.n	c0de12bc <memcmp+0x4c>
c0de129e:	3501      	adds	r5, #1
c0de12a0:	2301      	movs	r3, #1
c0de12a2:	3901      	subs	r1, #1
c0de12a4:	e004      	b.n	c0de12b0 <memcmp+0x40>
c0de12a6:	5cc2      	ldrb	r2, [r0, r3]
c0de12a8:	3301      	adds	r3, #1
c0de12aa:	5ccc      	ldrb	r4, [r1, r3]
c0de12ac:	42a2      	cmp	r2, r4
c0de12ae:	d105      	bne.n	c0de12bc <memcmp+0x4c>
c0de12b0:	42ab      	cmp	r3, r5
c0de12b2:	d1f8      	bne.n	c0de12a6 <memcmp+0x36>
c0de12b4:	2000      	movs	r0, #0
c0de12b6:	bd30      	pop	{r4, r5, pc}
c0de12b8:	1e55      	subs	r5, r2, #1
c0de12ba:	e7ec      	b.n	c0de1296 <memcmp+0x26>
c0de12bc:	1b10      	subs	r0, r2, r4
c0de12be:	e7fa      	b.n	c0de12b6 <memcmp+0x46>

c0de12c0 <memcpy>:
c0de12c0:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de12c2:	46c6      	mov	lr, r8
c0de12c4:	b500      	push	{lr}
c0de12c6:	2a0f      	cmp	r2, #15
c0de12c8:	d943      	bls.n	c0de1352 <memcpy+0x92>
c0de12ca:	000b      	movs	r3, r1
c0de12cc:	2603      	movs	r6, #3
c0de12ce:	4303      	orrs	r3, r0
c0de12d0:	401e      	ands	r6, r3
c0de12d2:	000c      	movs	r4, r1
c0de12d4:	0003      	movs	r3, r0
c0de12d6:	2e00      	cmp	r6, #0
c0de12d8:	d140      	bne.n	c0de135c <memcpy+0x9c>
c0de12da:	0015      	movs	r5, r2
c0de12dc:	3d10      	subs	r5, #16
c0de12de:	092d      	lsrs	r5, r5, #4
c0de12e0:	46ac      	mov	ip, r5
c0de12e2:	012d      	lsls	r5, r5, #4
c0de12e4:	46a8      	mov	r8, r5
c0de12e6:	4480      	add	r8, r0
c0de12e8:	e000      	b.n	c0de12ec <memcpy+0x2c>
c0de12ea:	003b      	movs	r3, r7
c0de12ec:	6867      	ldr	r7, [r4, #4]
c0de12ee:	6825      	ldr	r5, [r4, #0]
c0de12f0:	605f      	str	r7, [r3, #4]
c0de12f2:	68e7      	ldr	r7, [r4, #12]
c0de12f4:	601d      	str	r5, [r3, #0]
c0de12f6:	60df      	str	r7, [r3, #12]
c0de12f8:	001f      	movs	r7, r3
c0de12fa:	68a5      	ldr	r5, [r4, #8]
c0de12fc:	3710      	adds	r7, #16
c0de12fe:	609d      	str	r5, [r3, #8]
c0de1300:	3410      	adds	r4, #16
c0de1302:	4543      	cmp	r3, r8
c0de1304:	d1f1      	bne.n	c0de12ea <memcpy+0x2a>
c0de1306:	4665      	mov	r5, ip
c0de1308:	230f      	movs	r3, #15
c0de130a:	240c      	movs	r4, #12
c0de130c:	3501      	adds	r5, #1
c0de130e:	012d      	lsls	r5, r5, #4
c0de1310:	1949      	adds	r1, r1, r5
c0de1312:	4013      	ands	r3, r2
c0de1314:	1945      	adds	r5, r0, r5
c0de1316:	4214      	tst	r4, r2
c0de1318:	d023      	beq.n	c0de1362 <memcpy+0xa2>
c0de131a:	598c      	ldr	r4, [r1, r6]
c0de131c:	51ac      	str	r4, [r5, r6]
c0de131e:	3604      	adds	r6, #4
c0de1320:	1b9c      	subs	r4, r3, r6
c0de1322:	2c03      	cmp	r4, #3
c0de1324:	d8f9      	bhi.n	c0de131a <memcpy+0x5a>
c0de1326:	2403      	movs	r4, #3
c0de1328:	3b04      	subs	r3, #4
c0de132a:	089b      	lsrs	r3, r3, #2
c0de132c:	3301      	adds	r3, #1
c0de132e:	009b      	lsls	r3, r3, #2
c0de1330:	4022      	ands	r2, r4
c0de1332:	18ed      	adds	r5, r5, r3
c0de1334:	18c9      	adds	r1, r1, r3
c0de1336:	1e56      	subs	r6, r2, #1
c0de1338:	2a00      	cmp	r2, #0
c0de133a:	d007      	beq.n	c0de134c <memcpy+0x8c>
c0de133c:	2300      	movs	r3, #0
c0de133e:	e000      	b.n	c0de1342 <memcpy+0x82>
c0de1340:	0023      	movs	r3, r4
c0de1342:	5cca      	ldrb	r2, [r1, r3]
c0de1344:	1c5c      	adds	r4, r3, #1
c0de1346:	54ea      	strb	r2, [r5, r3]
c0de1348:	429e      	cmp	r6, r3
c0de134a:	d1f9      	bne.n	c0de1340 <memcpy+0x80>
c0de134c:	bc04      	pop	{r2}
c0de134e:	4690      	mov	r8, r2
c0de1350:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0de1352:	0005      	movs	r5, r0
c0de1354:	1e56      	subs	r6, r2, #1
c0de1356:	2a00      	cmp	r2, #0
c0de1358:	d1f0      	bne.n	c0de133c <memcpy+0x7c>
c0de135a:	e7f7      	b.n	c0de134c <memcpy+0x8c>
c0de135c:	1e56      	subs	r6, r2, #1
c0de135e:	0005      	movs	r5, r0
c0de1360:	e7ec      	b.n	c0de133c <memcpy+0x7c>
c0de1362:	001a      	movs	r2, r3
c0de1364:	e7f6      	b.n	c0de1354 <memcpy+0x94>
c0de1366:	46c0      	nop			; (mov r8, r8)

c0de1368 <memmove>:
c0de1368:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de136a:	46c6      	mov	lr, r8
c0de136c:	b500      	push	{lr}
c0de136e:	4288      	cmp	r0, r1
c0de1370:	d90c      	bls.n	c0de138c <memmove+0x24>
c0de1372:	188b      	adds	r3, r1, r2
c0de1374:	4298      	cmp	r0, r3
c0de1376:	d209      	bcs.n	c0de138c <memmove+0x24>
c0de1378:	1e53      	subs	r3, r2, #1
c0de137a:	2a00      	cmp	r2, #0
c0de137c:	d003      	beq.n	c0de1386 <memmove+0x1e>
c0de137e:	5cca      	ldrb	r2, [r1, r3]
c0de1380:	54c2      	strb	r2, [r0, r3]
c0de1382:	3b01      	subs	r3, #1
c0de1384:	d2fb      	bcs.n	c0de137e <memmove+0x16>
c0de1386:	bc04      	pop	{r2}
c0de1388:	4690      	mov	r8, r2
c0de138a:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0de138c:	2a0f      	cmp	r2, #15
c0de138e:	d80c      	bhi.n	c0de13aa <memmove+0x42>
c0de1390:	0005      	movs	r5, r0
c0de1392:	1e56      	subs	r6, r2, #1
c0de1394:	2a00      	cmp	r2, #0
c0de1396:	d0f6      	beq.n	c0de1386 <memmove+0x1e>
c0de1398:	2300      	movs	r3, #0
c0de139a:	e000      	b.n	c0de139e <memmove+0x36>
c0de139c:	0023      	movs	r3, r4
c0de139e:	5cca      	ldrb	r2, [r1, r3]
c0de13a0:	1c5c      	adds	r4, r3, #1
c0de13a2:	54ea      	strb	r2, [r5, r3]
c0de13a4:	429e      	cmp	r6, r3
c0de13a6:	d1f9      	bne.n	c0de139c <memmove+0x34>
c0de13a8:	e7ed      	b.n	c0de1386 <memmove+0x1e>
c0de13aa:	000b      	movs	r3, r1
c0de13ac:	2603      	movs	r6, #3
c0de13ae:	4303      	orrs	r3, r0
c0de13b0:	401e      	ands	r6, r3
c0de13b2:	000c      	movs	r4, r1
c0de13b4:	0003      	movs	r3, r0
c0de13b6:	2e00      	cmp	r6, #0
c0de13b8:	d12e      	bne.n	c0de1418 <memmove+0xb0>
c0de13ba:	0015      	movs	r5, r2
c0de13bc:	3d10      	subs	r5, #16
c0de13be:	092d      	lsrs	r5, r5, #4
c0de13c0:	46ac      	mov	ip, r5
c0de13c2:	012d      	lsls	r5, r5, #4
c0de13c4:	46a8      	mov	r8, r5
c0de13c6:	4480      	add	r8, r0
c0de13c8:	e000      	b.n	c0de13cc <memmove+0x64>
c0de13ca:	002b      	movs	r3, r5
c0de13cc:	001d      	movs	r5, r3
c0de13ce:	6827      	ldr	r7, [r4, #0]
c0de13d0:	3510      	adds	r5, #16
c0de13d2:	601f      	str	r7, [r3, #0]
c0de13d4:	6867      	ldr	r7, [r4, #4]
c0de13d6:	605f      	str	r7, [r3, #4]
c0de13d8:	68a7      	ldr	r7, [r4, #8]
c0de13da:	609f      	str	r7, [r3, #8]
c0de13dc:	68e7      	ldr	r7, [r4, #12]
c0de13de:	3410      	adds	r4, #16
c0de13e0:	60df      	str	r7, [r3, #12]
c0de13e2:	4543      	cmp	r3, r8
c0de13e4:	d1f1      	bne.n	c0de13ca <memmove+0x62>
c0de13e6:	4665      	mov	r5, ip
c0de13e8:	230f      	movs	r3, #15
c0de13ea:	240c      	movs	r4, #12
c0de13ec:	3501      	adds	r5, #1
c0de13ee:	012d      	lsls	r5, r5, #4
c0de13f0:	1949      	adds	r1, r1, r5
c0de13f2:	4013      	ands	r3, r2
c0de13f4:	1945      	adds	r5, r0, r5
c0de13f6:	4214      	tst	r4, r2
c0de13f8:	d011      	beq.n	c0de141e <memmove+0xb6>
c0de13fa:	598c      	ldr	r4, [r1, r6]
c0de13fc:	51ac      	str	r4, [r5, r6]
c0de13fe:	3604      	adds	r6, #4
c0de1400:	1b9c      	subs	r4, r3, r6
c0de1402:	2c03      	cmp	r4, #3
c0de1404:	d8f9      	bhi.n	c0de13fa <memmove+0x92>
c0de1406:	2403      	movs	r4, #3
c0de1408:	3b04      	subs	r3, #4
c0de140a:	089b      	lsrs	r3, r3, #2
c0de140c:	3301      	adds	r3, #1
c0de140e:	009b      	lsls	r3, r3, #2
c0de1410:	18ed      	adds	r5, r5, r3
c0de1412:	18c9      	adds	r1, r1, r3
c0de1414:	4022      	ands	r2, r4
c0de1416:	e7bc      	b.n	c0de1392 <memmove+0x2a>
c0de1418:	1e56      	subs	r6, r2, #1
c0de141a:	0005      	movs	r5, r0
c0de141c:	e7bc      	b.n	c0de1398 <memmove+0x30>
c0de141e:	001a      	movs	r2, r3
c0de1420:	e7b7      	b.n	c0de1392 <memmove+0x2a>
c0de1422:	46c0      	nop			; (mov r8, r8)

c0de1424 <memset>:
c0de1424:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de1426:	0005      	movs	r5, r0
c0de1428:	0783      	lsls	r3, r0, #30
c0de142a:	d04a      	beq.n	c0de14c2 <memset+0x9e>
c0de142c:	1e54      	subs	r4, r2, #1
c0de142e:	2a00      	cmp	r2, #0
c0de1430:	d044      	beq.n	c0de14bc <memset+0x98>
c0de1432:	b2ce      	uxtb	r6, r1
c0de1434:	0003      	movs	r3, r0
c0de1436:	2203      	movs	r2, #3
c0de1438:	e002      	b.n	c0de1440 <memset+0x1c>
c0de143a:	3501      	adds	r5, #1
c0de143c:	3c01      	subs	r4, #1
c0de143e:	d33d      	bcc.n	c0de14bc <memset+0x98>
c0de1440:	3301      	adds	r3, #1
c0de1442:	702e      	strb	r6, [r5, #0]
c0de1444:	4213      	tst	r3, r2
c0de1446:	d1f8      	bne.n	c0de143a <memset+0x16>
c0de1448:	2c03      	cmp	r4, #3
c0de144a:	d92f      	bls.n	c0de14ac <memset+0x88>
c0de144c:	22ff      	movs	r2, #255	; 0xff
c0de144e:	400a      	ands	r2, r1
c0de1450:	0215      	lsls	r5, r2, #8
c0de1452:	4315      	orrs	r5, r2
c0de1454:	042a      	lsls	r2, r5, #16
c0de1456:	4315      	orrs	r5, r2
c0de1458:	2c0f      	cmp	r4, #15
c0de145a:	d935      	bls.n	c0de14c8 <memset+0xa4>
c0de145c:	0027      	movs	r7, r4
c0de145e:	3f10      	subs	r7, #16
c0de1460:	093f      	lsrs	r7, r7, #4
c0de1462:	013e      	lsls	r6, r7, #4
c0de1464:	46b4      	mov	ip, r6
c0de1466:	001e      	movs	r6, r3
c0de1468:	001a      	movs	r2, r3
c0de146a:	3610      	adds	r6, #16
c0de146c:	4466      	add	r6, ip
c0de146e:	6015      	str	r5, [r2, #0]
c0de1470:	6055      	str	r5, [r2, #4]
c0de1472:	6095      	str	r5, [r2, #8]
c0de1474:	60d5      	str	r5, [r2, #12]
c0de1476:	3210      	adds	r2, #16
c0de1478:	42b2      	cmp	r2, r6
c0de147a:	d1f8      	bne.n	c0de146e <memset+0x4a>
c0de147c:	260f      	movs	r6, #15
c0de147e:	220c      	movs	r2, #12
c0de1480:	3701      	adds	r7, #1
c0de1482:	013f      	lsls	r7, r7, #4
c0de1484:	4026      	ands	r6, r4
c0de1486:	19db      	adds	r3, r3, r7
c0de1488:	0037      	movs	r7, r6
c0de148a:	4222      	tst	r2, r4
c0de148c:	d017      	beq.n	c0de14be <memset+0x9a>
c0de148e:	1f3e      	subs	r6, r7, #4
c0de1490:	08b6      	lsrs	r6, r6, #2
c0de1492:	00b4      	lsls	r4, r6, #2
c0de1494:	46a4      	mov	ip, r4
c0de1496:	001a      	movs	r2, r3
c0de1498:	1d1c      	adds	r4, r3, #4
c0de149a:	4464      	add	r4, ip
c0de149c:	c220      	stmia	r2!, {r5}
c0de149e:	42a2      	cmp	r2, r4
c0de14a0:	d1fc      	bne.n	c0de149c <memset+0x78>
c0de14a2:	2403      	movs	r4, #3
c0de14a4:	3601      	adds	r6, #1
c0de14a6:	00b6      	lsls	r6, r6, #2
c0de14a8:	199b      	adds	r3, r3, r6
c0de14aa:	403c      	ands	r4, r7
c0de14ac:	2c00      	cmp	r4, #0
c0de14ae:	d005      	beq.n	c0de14bc <memset+0x98>
c0de14b0:	b2c9      	uxtb	r1, r1
c0de14b2:	191c      	adds	r4, r3, r4
c0de14b4:	7019      	strb	r1, [r3, #0]
c0de14b6:	3301      	adds	r3, #1
c0de14b8:	429c      	cmp	r4, r3
c0de14ba:	d1fb      	bne.n	c0de14b4 <memset+0x90>
c0de14bc:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0de14be:	0034      	movs	r4, r6
c0de14c0:	e7f4      	b.n	c0de14ac <memset+0x88>
c0de14c2:	0014      	movs	r4, r2
c0de14c4:	0003      	movs	r3, r0
c0de14c6:	e7bf      	b.n	c0de1448 <memset+0x24>
c0de14c8:	0027      	movs	r7, r4
c0de14ca:	e7e0      	b.n	c0de148e <memset+0x6a>

c0de14cc <setjmp>:
c0de14cc:	c0f0      	stmia	r0!, {r4, r5, r6, r7}
c0de14ce:	4641      	mov	r1, r8
c0de14d0:	464a      	mov	r2, r9
c0de14d2:	4653      	mov	r3, sl
c0de14d4:	465c      	mov	r4, fp
c0de14d6:	466d      	mov	r5, sp
c0de14d8:	4676      	mov	r6, lr
c0de14da:	c07e      	stmia	r0!, {r1, r2, r3, r4, r5, r6}
c0de14dc:	3828      	subs	r0, #40	; 0x28
c0de14de:	c8f0      	ldmia	r0!, {r4, r5, r6, r7}
c0de14e0:	2000      	movs	r0, #0
c0de14e2:	4770      	bx	lr

c0de14e4 <longjmp>:
c0de14e4:	3010      	adds	r0, #16
c0de14e6:	c87c      	ldmia	r0!, {r2, r3, r4, r5, r6}
c0de14e8:	4690      	mov	r8, r2
c0de14ea:	4699      	mov	r9, r3
c0de14ec:	46a2      	mov	sl, r4
c0de14ee:	46ab      	mov	fp, r5
c0de14f0:	46b5      	mov	sp, r6
c0de14f2:	c808      	ldmia	r0!, {r3}
c0de14f4:	3828      	subs	r0, #40	; 0x28
c0de14f6:	c8f0      	ldmia	r0!, {r4, r5, r6, r7}
c0de14f8:	1c08      	adds	r0, r1, #0
c0de14fa:	d100      	bne.n	c0de14fe <longjmp+0x1a>
c0de14fc:	2001      	movs	r0, #1
c0de14fe:	4718      	bx	r3

c0de1500 <strlcat>:
c0de1500:	b570      	push	{r4, r5, r6, lr}
c0de1502:	2a00      	cmp	r2, #0
c0de1504:	d02a      	beq.n	c0de155c <strlcat+0x5c>
c0de1506:	7803      	ldrb	r3, [r0, #0]
c0de1508:	2b00      	cmp	r3, #0
c0de150a:	d029      	beq.n	c0de1560 <strlcat+0x60>
c0de150c:	1884      	adds	r4, r0, r2
c0de150e:	0003      	movs	r3, r0
c0de1510:	e002      	b.n	c0de1518 <strlcat+0x18>
c0de1512:	781d      	ldrb	r5, [r3, #0]
c0de1514:	2d00      	cmp	r5, #0
c0de1516:	d018      	beq.n	c0de154a <strlcat+0x4a>
c0de1518:	3301      	adds	r3, #1
c0de151a:	42a3      	cmp	r3, r4
c0de151c:	d1f9      	bne.n	c0de1512 <strlcat+0x12>
c0de151e:	1a26      	subs	r6, r4, r0
c0de1520:	1b92      	subs	r2, r2, r6
c0de1522:	d016      	beq.n	c0de1552 <strlcat+0x52>
c0de1524:	780d      	ldrb	r5, [r1, #0]
c0de1526:	000b      	movs	r3, r1
c0de1528:	2d00      	cmp	r5, #0
c0de152a:	d00a      	beq.n	c0de1542 <strlcat+0x42>
c0de152c:	2a01      	cmp	r2, #1
c0de152e:	d002      	beq.n	c0de1536 <strlcat+0x36>
c0de1530:	7025      	strb	r5, [r4, #0]
c0de1532:	3a01      	subs	r2, #1
c0de1534:	3401      	adds	r4, #1
c0de1536:	3301      	adds	r3, #1
c0de1538:	781d      	ldrb	r5, [r3, #0]
c0de153a:	2d00      	cmp	r5, #0
c0de153c:	d1f6      	bne.n	c0de152c <strlcat+0x2c>
c0de153e:	1a5b      	subs	r3, r3, r1
c0de1540:	18f6      	adds	r6, r6, r3
c0de1542:	2300      	movs	r3, #0
c0de1544:	7023      	strb	r3, [r4, #0]
c0de1546:	0030      	movs	r0, r6
c0de1548:	bd70      	pop	{r4, r5, r6, pc}
c0de154a:	001c      	movs	r4, r3
c0de154c:	1a26      	subs	r6, r4, r0
c0de154e:	1b92      	subs	r2, r2, r6
c0de1550:	d1e8      	bne.n	c0de1524 <strlcat+0x24>
c0de1552:	0008      	movs	r0, r1
c0de1554:	f000 f82e 	bl	c0de15b4 <strlen>
c0de1558:	1836      	adds	r6, r6, r0
c0de155a:	e7f4      	b.n	c0de1546 <strlcat+0x46>
c0de155c:	2600      	movs	r6, #0
c0de155e:	e7f8      	b.n	c0de1552 <strlcat+0x52>
c0de1560:	0004      	movs	r4, r0
c0de1562:	2600      	movs	r6, #0
c0de1564:	e7de      	b.n	c0de1524 <strlcat+0x24>
c0de1566:	46c0      	nop			; (mov r8, r8)

c0de1568 <strlcpy>:
c0de1568:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de156a:	2a00      	cmp	r2, #0
c0de156c:	d013      	beq.n	c0de1596 <strlcpy+0x2e>
c0de156e:	3a01      	subs	r2, #1
c0de1570:	2a00      	cmp	r2, #0
c0de1572:	d019      	beq.n	c0de15a8 <strlcpy+0x40>
c0de1574:	2300      	movs	r3, #0
c0de1576:	1c4f      	adds	r7, r1, #1
c0de1578:	1c46      	adds	r6, r0, #1
c0de157a:	e002      	b.n	c0de1582 <strlcpy+0x1a>
c0de157c:	3301      	adds	r3, #1
c0de157e:	429a      	cmp	r2, r3
c0de1580:	d016      	beq.n	c0de15b0 <strlcpy+0x48>
c0de1582:	18f5      	adds	r5, r6, r3
c0de1584:	46ac      	mov	ip, r5
c0de1586:	5ccd      	ldrb	r5, [r1, r3]
c0de1588:	18fc      	adds	r4, r7, r3
c0de158a:	54c5      	strb	r5, [r0, r3]
c0de158c:	2d00      	cmp	r5, #0
c0de158e:	d1f5      	bne.n	c0de157c <strlcpy+0x14>
c0de1590:	1a60      	subs	r0, r4, r1
c0de1592:	3801      	subs	r0, #1
c0de1594:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0de1596:	000c      	movs	r4, r1
c0de1598:	0023      	movs	r3, r4
c0de159a:	3301      	adds	r3, #1
c0de159c:	1e5a      	subs	r2, r3, #1
c0de159e:	7812      	ldrb	r2, [r2, #0]
c0de15a0:	001c      	movs	r4, r3
c0de15a2:	2a00      	cmp	r2, #0
c0de15a4:	d1f9      	bne.n	c0de159a <strlcpy+0x32>
c0de15a6:	e7f3      	b.n	c0de1590 <strlcpy+0x28>
c0de15a8:	000c      	movs	r4, r1
c0de15aa:	2300      	movs	r3, #0
c0de15ac:	7003      	strb	r3, [r0, #0]
c0de15ae:	e7f3      	b.n	c0de1598 <strlcpy+0x30>
c0de15b0:	4660      	mov	r0, ip
c0de15b2:	e7fa      	b.n	c0de15aa <strlcpy+0x42>

c0de15b4 <strlen>:
c0de15b4:	b510      	push	{r4, lr}
c0de15b6:	0783      	lsls	r3, r0, #30
c0de15b8:	d027      	beq.n	c0de160a <strlen+0x56>
c0de15ba:	7803      	ldrb	r3, [r0, #0]
c0de15bc:	2b00      	cmp	r3, #0
c0de15be:	d026      	beq.n	c0de160e <strlen+0x5a>
c0de15c0:	0003      	movs	r3, r0
c0de15c2:	2103      	movs	r1, #3
c0de15c4:	e002      	b.n	c0de15cc <strlen+0x18>
c0de15c6:	781a      	ldrb	r2, [r3, #0]
c0de15c8:	2a00      	cmp	r2, #0
c0de15ca:	d01c      	beq.n	c0de1606 <strlen+0x52>
c0de15cc:	3301      	adds	r3, #1
c0de15ce:	420b      	tst	r3, r1
c0de15d0:	d1f9      	bne.n	c0de15c6 <strlen+0x12>
c0de15d2:	6819      	ldr	r1, [r3, #0]
c0de15d4:	4a0f      	ldr	r2, [pc, #60]	; (c0de1614 <strlen+0x60>)
c0de15d6:	4c10      	ldr	r4, [pc, #64]	; (c0de1618 <strlen+0x64>)
c0de15d8:	188a      	adds	r2, r1, r2
c0de15da:	438a      	bics	r2, r1
c0de15dc:	4222      	tst	r2, r4
c0de15de:	d10f      	bne.n	c0de1600 <strlen+0x4c>
c0de15e0:	3304      	adds	r3, #4
c0de15e2:	6819      	ldr	r1, [r3, #0]
c0de15e4:	4a0b      	ldr	r2, [pc, #44]	; (c0de1614 <strlen+0x60>)
c0de15e6:	188a      	adds	r2, r1, r2
c0de15e8:	438a      	bics	r2, r1
c0de15ea:	4222      	tst	r2, r4
c0de15ec:	d108      	bne.n	c0de1600 <strlen+0x4c>
c0de15ee:	3304      	adds	r3, #4
c0de15f0:	6819      	ldr	r1, [r3, #0]
c0de15f2:	4a08      	ldr	r2, [pc, #32]	; (c0de1614 <strlen+0x60>)
c0de15f4:	188a      	adds	r2, r1, r2
c0de15f6:	438a      	bics	r2, r1
c0de15f8:	4222      	tst	r2, r4
c0de15fa:	d0f1      	beq.n	c0de15e0 <strlen+0x2c>
c0de15fc:	e000      	b.n	c0de1600 <strlen+0x4c>
c0de15fe:	3301      	adds	r3, #1
c0de1600:	781a      	ldrb	r2, [r3, #0]
c0de1602:	2a00      	cmp	r2, #0
c0de1604:	d1fb      	bne.n	c0de15fe <strlen+0x4a>
c0de1606:	1a18      	subs	r0, r3, r0
c0de1608:	bd10      	pop	{r4, pc}
c0de160a:	0003      	movs	r3, r0
c0de160c:	e7e1      	b.n	c0de15d2 <strlen+0x1e>
c0de160e:	2000      	movs	r0, #0
c0de1610:	e7fa      	b.n	c0de1608 <strlen+0x54>
c0de1612:	46c0      	nop			; (mov r8, r8)
c0de1614:	fefefeff 	.word	0xfefefeff
c0de1618:	80808080 	.word	0x80808080

c0de161c <strnlen>:
c0de161c:	b510      	push	{r4, lr}
c0de161e:	2900      	cmp	r1, #0
c0de1620:	d00b      	beq.n	c0de163a <strnlen+0x1e>
c0de1622:	7803      	ldrb	r3, [r0, #0]
c0de1624:	2b00      	cmp	r3, #0
c0de1626:	d00c      	beq.n	c0de1642 <strnlen+0x26>
c0de1628:	1844      	adds	r4, r0, r1
c0de162a:	0003      	movs	r3, r0
c0de162c:	e002      	b.n	c0de1634 <strnlen+0x18>
c0de162e:	781a      	ldrb	r2, [r3, #0]
c0de1630:	2a00      	cmp	r2, #0
c0de1632:	d004      	beq.n	c0de163e <strnlen+0x22>
c0de1634:	3301      	adds	r3, #1
c0de1636:	42a3      	cmp	r3, r4
c0de1638:	d1f9      	bne.n	c0de162e <strnlen+0x12>
c0de163a:	0008      	movs	r0, r1
c0de163c:	bd10      	pop	{r4, pc}
c0de163e:	1a19      	subs	r1, r3, r0
c0de1640:	e7fb      	b.n	c0de163a <strnlen+0x1e>
c0de1642:	2100      	movs	r1, #0
c0de1644:	e7f9      	b.n	c0de163a <strnlen+0x1e>
c0de1646:	46c0      	nop			; (mov r8, r8)

c0de1648 <HARVEST_SELECTORS>:
c0de1648:	5f25 b6b5 7d4d 2e1a fc3a a694 b912 3d18     %_..M}..:......=
c0de1658:	d8ee e9fa 3bd9 916a 4144 0049 7830 3030     .....;j.DAI.0x00
c0de1668:	3030 3030 3030 3030 3030 3030 3030 3030     0000000000000000
c0de1678:	3030 3030 3030 3030 3030 3030 3030 3030     0000000000000000
c0de1688:	3030 3030 3030 5000 756c 6967 206e 6170     000000.Plugin pa
c0de1698:	6172 656d 6574 7372 7320 7274 6375 7574     rameters structu
c0de16a8:	6572 6920 2073 6962 6767 7265 7420 6168     re is bigger tha
c0de16b8:	206e 6c61 6f6c 6577 2064 6973 657a 000a     n allowed size..
c0de16c8:	7830 3531 3364 3641 4234 6432 6135 3962     0x15d3A64B2d5ab9
c0de16d8:	3145 3235 3146 3536 3339 6443 6265 3463     E152F16593Cdebc4
c0de16e8:	4262 3631 4235 4235 4134 5300 6c65 6365     bB165B5B4A.Selec
c0de16f8:	6f74 2072 6e69 6564 3a78 2520 2064 6f6e     tor index: %d no
c0de1708:	2074 7573 7070 726f 6574 0a64 3000 6678     t supported..0xf
c0de1718:	3330 3835 3865 3363 4443 4635 3261 3833     0358e8c3CD5Fa238
c0de1728:	3261 3339 3130 3064 4562 3361 3644 4133     a29301d0bEa3D63A
c0de1738:	3731 4562 4264 0045 4157 4e52 4e49 0047     17bEdBE.WARNING.
c0de1748:	7830 3531 3137 4465 6230 6465 4434 3839     0x1571eD0bed4D98
c0de1758:	6637 3265 3462 3839 6444 6142 3745 4644     7fe2b498DdBaE7DF
c0de1768:	3141 3539 3931 3646 3135 5000 6f6f 006c     A19519F651.Pool.
c0de1778:	6d41 756f 746e 2000 3000 6178 3762 4146     Amount. .0xab7FA
c0de1788:	4232 3932 3538 4342 6663 3143 6333 4436     2B2985BCcfC13c6D
c0de1798:	3638 3162 3544 3141 3437 3638 6261 6531     86b1D5A17486ab1e
c0de17a8:	3430 0043 5246 4d4f 415f 4444 4552 5353     04C.FROM_ADDRESS
c0de17b8:	203a 2500 3230 0078 6148 7672 7365 0074     : .%02x.Harvest.
c0de17c8:	6156 6c75 0074 5355 4344 4500 6874 7265     Vault.USDC.Ether
c0de17d8:	7565 006d 6c43 6961 006d 0030 6150 6172     eum.Claim.0.Para
c0de17e8:	206d 6f6e 2074 7573 7070 726f 6574 3a64     m not supported:
c0de17f8:	2520 0a64 5300 6174 656b 4600 6f72 206d      %d..Stake.From 
c0de1808:	6f54 656b 006e 7845 6563 7470 6f69 206e     Token.Exception 
c0de1818:	7830 7825 6320 7561 6867 0a74 4500 4854     0x%x caught..ETH
c0de1828:	5500 6b6e 6f6e 6e77 7420 6b6f 6e65 4500     .Unknown token.E
c0de1838:	6978 0074                                   xit.

c0de183c <HEXDIGITS>:
c0de183c:	3130 3332 3534 3736 3938 6261 6463 6665     0123456789abcdef
c0de184c:	6500 6378 7065 6974 6e6f 255b 5d64 203a     .exception[%d]: 
c0de185c:	524c 303d 2578 3830 0a58 4500 5252 524f     LR=0x%08X..ERROR
c0de186c:	3000 0078 6553 656c 7463 726f 4920 646e     .0x.Selector Ind
c0de187c:	7865 6e20 746f 7320 7075 6f70 7472 6465     ex not supported
c0de188c:	203a 6425 000a 6e55 6168 646e 656c 2064     : %d..Unhandled 
c0de189c:	656d 7373 6761 2065 6425 000a 6f43 746e     message %d..Cont
c0de18ac:	6172 7463 2073 656c 676e 6874 203a 6425     racts length: %d
c0de18bc:	000a 6957 6f64 7020 756c 6967 206e 7270     ..Wido plugin pr
c0de18cc:	766f 6469 2065 6f74 656b 3a6e 3020 2578     ovide token: 0x%
c0de18dc:	0a70 3f00 3f3f 6600 4144 0049 000a 4649     p..???.fDAI...IF
c0de18ec:	5241 004d 5566 4453 0043 5246 4d4f 415f     ARM.fUSDC.FROM_A
c0de18fc:	4f4d 4e55 3a54 0020 6957 6f64 4520 6578     MOUNT: .Wido Exe
c0de190c:	7563 6574 5200 6365 6965 6576 2064 6e61     cute.Received an
c0de191c:	6920 766e 6c61 6469 7320 7263 6565 496e      invalid screenI
c0de192c:	646e 7865 000a 6c70 6775 6e69 7020 6f72     ndex..plugin pro
c0de193c:	6976 6564 7020 7261 6d61 7465 7265 203a     vide parameter: 
c0de194c:	666f 7366 7465 2520 0a64 7942 6574 3a73     offset %d.Bytes:
c0de195c:	2520 2a2e 0a48 5700 7469 6468 6172 0077      %.*H..Withdraw.
c0de196c:	4d00 4753 4120 6464 6572 7373 203a 7325     .MSG Address: %s
c0de197c:	000a 6544 6f70 6973 0074 4966 4146 4d52     ..Deposit.fIFARM
c0de198c:	4d00 7369 6973 676e 7320 6c65 6365 6f74     .Missing selecto
c0de199c:	4972 646e 7865 203a 6425 000a 7830 4634     rIndex: %d..0x4F
c0de19ac:	6337 3832 4363 3062 3146 6244 3164 3833     7c28cCb0F1Dbd138
c0de19bc:	3238 3930 3643 6537 6345 3332 3234 3337     8209C67eEc234273
c0de19cc:	3843 3837 6442 d400                         C878Bd..

c0de19d4 <contracts>:
c0de19d4:	1781 c0de 1660 c0de 0012 0000 18e3 c0de     ....`...........
c0de19e4:	0012 0000 16c8 c0de 18e3 c0de 0012 0000     ................
c0de19f4:	196c c0de 0012 0000 1748 c0de 18ea c0de     l.......H.......
c0de1a04:	0012 0000 1986 c0de 0012 0000 1715 c0de     ................
c0de1a14:	17ce c0de 0006 0000 18f0 c0de 0012 0000     ................
c0de1a24:	19a8 c0de 18f0 c0de 0012 0000 196c c0de     ............l...
c0de1a34:	0012 0000                                   ....

c0de1a38 <g_pcHex>:
c0de1a38:	3130 3332 3534 3736 3938 6261 6463 6665     0123456789abcdef

c0de1a48 <g_pcHex_cap>:
c0de1a48:	3130 3332 3534 3736 3938 4241 4443 4645     0123456789ABCDEF

c0de1a58 <_etext>:
c0de1a58:	d4d4      	bmi.n	c0de1a04 <contracts+0x30>
c0de1a5a:	d4d4      	bmi.n	c0de1a06 <contracts+0x32>
c0de1a5c:	d4d4      	bmi.n	c0de1a08 <contracts+0x34>
c0de1a5e:	d4d4      	bmi.n	c0de1a0a <contracts+0x36>
c0de1a60:	d4d4      	bmi.n	c0de1a0c <contracts+0x38>
c0de1a62:	d4d4      	bmi.n	c0de1a0e <contracts+0x3a>
c0de1a64:	d4d4      	bmi.n	c0de1a10 <contracts+0x3c>
c0de1a66:	d4d4      	bmi.n	c0de1a12 <contracts+0x3e>
c0de1a68:	d4d4      	bmi.n	c0de1a14 <contracts+0x40>
c0de1a6a:	d4d4      	bmi.n	c0de1a16 <contracts+0x42>
c0de1a6c:	d4d4      	bmi.n	c0de1a18 <contracts+0x44>
c0de1a6e:	d4d4      	bmi.n	c0de1a1a <contracts+0x46>
c0de1a70:	d4d4      	bmi.n	c0de1a1c <contracts+0x48>
c0de1a72:	d4d4      	bmi.n	c0de1a1e <contracts+0x4a>
c0de1a74:	d4d4      	bmi.n	c0de1a20 <contracts+0x4c>
c0de1a76:	d4d4      	bmi.n	c0de1a22 <contracts+0x4e>
c0de1a78:	d4d4      	bmi.n	c0de1a24 <contracts+0x50>
c0de1a7a:	d4d4      	bmi.n	c0de1a26 <contracts+0x52>
c0de1a7c:	d4d4      	bmi.n	c0de1a28 <contracts+0x54>
c0de1a7e:	d4d4      	bmi.n	c0de1a2a <contracts+0x56>
c0de1a80:	d4d4      	bmi.n	c0de1a2c <contracts+0x58>
c0de1a82:	d4d4      	bmi.n	c0de1a2e <contracts+0x5a>
c0de1a84:	d4d4      	bmi.n	c0de1a30 <contracts+0x5c>
c0de1a86:	d4d4      	bmi.n	c0de1a32 <contracts+0x5e>
c0de1a88:	d4d4      	bmi.n	c0de1a34 <contracts+0x60>
c0de1a8a:	d4d4      	bmi.n	c0de1a36 <contracts+0x62>
c0de1a8c:	d4d4      	bmi.n	c0de1a38 <g_pcHex>
c0de1a8e:	d4d4      	bmi.n	c0de1a3a <g_pcHex+0x2>
c0de1a90:	d4d4      	bmi.n	c0de1a3c <g_pcHex+0x4>
c0de1a92:	d4d4      	bmi.n	c0de1a3e <g_pcHex+0x6>
c0de1a94:	d4d4      	bmi.n	c0de1a40 <g_pcHex+0x8>
c0de1a96:	d4d4      	bmi.n	c0de1a42 <g_pcHex+0xa>
c0de1a98:	d4d4      	bmi.n	c0de1a44 <g_pcHex+0xc>
c0de1a9a:	d4d4      	bmi.n	c0de1a46 <g_pcHex+0xe>
c0de1a9c:	d4d4      	bmi.n	c0de1a48 <g_pcHex_cap>
c0de1a9e:	d4d4      	bmi.n	c0de1a4a <g_pcHex_cap+0x2>
c0de1aa0:	d4d4      	bmi.n	c0de1a4c <g_pcHex_cap+0x4>
c0de1aa2:	d4d4      	bmi.n	c0de1a4e <g_pcHex_cap+0x6>
c0de1aa4:	d4d4      	bmi.n	c0de1a50 <g_pcHex_cap+0x8>
c0de1aa6:	d4d4      	bmi.n	c0de1a52 <g_pcHex_cap+0xa>
c0de1aa8:	d4d4      	bmi.n	c0de1a54 <g_pcHex_cap+0xc>
c0de1aaa:	d4d4      	bmi.n	c0de1a56 <g_pcHex_cap+0xe>
c0de1aac:	d4d4      	bmi.n	c0de1a58 <_etext>
c0de1aae:	d4d4      	bmi.n	c0de1a5a <_etext+0x2>
c0de1ab0:	d4d4      	bmi.n	c0de1a5c <_etext+0x4>
c0de1ab2:	d4d4      	bmi.n	c0de1a5e <_etext+0x6>
c0de1ab4:	d4d4      	bmi.n	c0de1a60 <_etext+0x8>
c0de1ab6:	d4d4      	bmi.n	c0de1a62 <_etext+0xa>
c0de1ab8:	d4d4      	bmi.n	c0de1a64 <_etext+0xc>
c0de1aba:	d4d4      	bmi.n	c0de1a66 <_etext+0xe>
c0de1abc:	d4d4      	bmi.n	c0de1a68 <_etext+0x10>
c0de1abe:	d4d4      	bmi.n	c0de1a6a <_etext+0x12>
c0de1ac0:	d4d4      	bmi.n	c0de1a6c <_etext+0x14>
c0de1ac2:	d4d4      	bmi.n	c0de1a6e <_etext+0x16>
c0de1ac4:	d4d4      	bmi.n	c0de1a70 <_etext+0x18>
c0de1ac6:	d4d4      	bmi.n	c0de1a72 <_etext+0x1a>
c0de1ac8:	d4d4      	bmi.n	c0de1a74 <_etext+0x1c>
c0de1aca:	d4d4      	bmi.n	c0de1a76 <_etext+0x1e>
c0de1acc:	d4d4      	bmi.n	c0de1a78 <_etext+0x20>
c0de1ace:	d4d4      	bmi.n	c0de1a7a <_etext+0x22>
c0de1ad0:	d4d4      	bmi.n	c0de1a7c <_etext+0x24>
c0de1ad2:	d4d4      	bmi.n	c0de1a7e <_etext+0x26>
c0de1ad4:	d4d4      	bmi.n	c0de1a80 <_etext+0x28>
c0de1ad6:	d4d4      	bmi.n	c0de1a82 <_etext+0x2a>
c0de1ad8:	d4d4      	bmi.n	c0de1a84 <_etext+0x2c>
c0de1ada:	d4d4      	bmi.n	c0de1a86 <_etext+0x2e>
c0de1adc:	d4d4      	bmi.n	c0de1a88 <_etext+0x30>
c0de1ade:	d4d4      	bmi.n	c0de1a8a <_etext+0x32>
c0de1ae0:	d4d4      	bmi.n	c0de1a8c <_etext+0x34>
c0de1ae2:	d4d4      	bmi.n	c0de1a8e <_etext+0x36>
c0de1ae4:	d4d4      	bmi.n	c0de1a90 <_etext+0x38>
c0de1ae6:	d4d4      	bmi.n	c0de1a92 <_etext+0x3a>
c0de1ae8:	d4d4      	bmi.n	c0de1a94 <_etext+0x3c>
c0de1aea:	d4d4      	bmi.n	c0de1a96 <_etext+0x3e>
c0de1aec:	d4d4      	bmi.n	c0de1a98 <_etext+0x40>
c0de1aee:	d4d4      	bmi.n	c0de1a9a <_etext+0x42>
c0de1af0:	d4d4      	bmi.n	c0de1a9c <_etext+0x44>
c0de1af2:	d4d4      	bmi.n	c0de1a9e <_etext+0x46>
c0de1af4:	d4d4      	bmi.n	c0de1aa0 <_etext+0x48>
c0de1af6:	d4d4      	bmi.n	c0de1aa2 <_etext+0x4a>
c0de1af8:	d4d4      	bmi.n	c0de1aa4 <_etext+0x4c>
c0de1afa:	d4d4      	bmi.n	c0de1aa6 <_etext+0x4e>
c0de1afc:	d4d4      	bmi.n	c0de1aa8 <_etext+0x50>
c0de1afe:	d4d4      	bmi.n	c0de1aaa <_etext+0x52>
