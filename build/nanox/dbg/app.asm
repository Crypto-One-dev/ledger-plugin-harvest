
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
c0de0008:	f000 fc9e 	bl	c0de0948 <os_boot>
c0de000c:	466d      	mov	r5, sp

    // Try catch block. Please read the docs for more information on how to use those!
    BEGIN_TRY {
        TRY {
c0de000e:	4628      	mov	r0, r5
c0de0010:	f001 f9d4 	bl	c0de13bc <setjmp>
c0de0014:	85a8      	strh	r0, [r5, #44]	; 0x2c
c0de0016:	b285      	uxth	r5, r0
c0de0018:	4668      	mov	r0, sp
c0de001a:	2d00      	cmp	r5, #0
c0de001c:	d10d      	bne.n	c0de003a <main+0x3a>
c0de001e:	f000 feab 	bl	c0de0d78 <try_context_set>
c0de0022:	900a      	str	r0, [sp, #40]	; 0x28
// get API level
SYSCALL unsigned int get_api_level(void);

#ifndef HAVE_BOLOS
static inline void check_api_level(unsigned int apiLevel) {
  if (apiLevel < get_api_level()) {
c0de0024:	f000 fe6d 	bl	c0de0d02 <get_api_level>
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
c0de0030:	f000 fc7c 	bl	c0de092c <call_app_ethereum>
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
c0de0040:	f000 fe9a 	bl	c0de0d78 <try_context_set>
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
c0de0064:	f000 fc96 	bl	c0de0994 <mcu_usb_printf>
c0de0068:	e00b      	b.n	c0de0082 <main+0x82>
c0de006a:	20ff      	movs	r0, #255	; 0xff
    os_sched_exit(-1);
c0de006c:	f000 fe66 	bl	c0de0d3c <os_sched_exit>
                if (args[0] != ETH_PLUGIN_CHECK_PRESENCE) {
c0de0070:	6820      	ldr	r0, [r4, #0]
c0de0072:	2183      	movs	r1, #131	; 0x83
c0de0074:	0049      	lsls	r1, r1, #1
c0de0076:	31f9      	adds	r1, #249	; 0xf9
c0de0078:	4288      	cmp	r0, r1
c0de007a:	d002      	beq.n	c0de0082 <main+0x82>
                    dispatch_plugin_calls(args[0], (void *) args[1]);
c0de007c:	6861      	ldr	r1, [r4, #4]
c0de007e:	f000 fc1b 	bl	c0de08b8 <dispatch_plugin_calls>
        FINALLY {
c0de0082:	f000 fe71 	bl	c0de0d68 <try_context_get>
c0de0086:	4669      	mov	r1, sp
c0de0088:	4288      	cmp	r0, r1
c0de008a:	d102      	bne.n	c0de0092 <main+0x92>
c0de008c:	980a      	ldr	r0, [sp, #40]	; 0x28
c0de008e:	f000 fe73 	bl	c0de0d78 <try_context_set>
            os_lib_end();
c0de0092:	f000 fe4b 	bl	c0de0d2c <os_lib_end>
c0de0096:	46c0      	nop			; (mov r8, r8)
c0de0098:	00006502 	.word	0x00006502
c0de009c:	00001622 	.word	0x00001622

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
c0de010a:	f001 f9ff 	bl	c0de150c <strnlen>
        strlcat((char *) locals_union.tmp + offset, "0x", sizeof(locals_union.tmp) - offset);
c0de010e:	9901      	ldr	r1, [sp, #4]
c0de0110:	180b      	adds	r3, r1, r0
c0de0112:	1a3a      	subs	r2, r7, r0
c0de0114:	4925      	ldr	r1, [pc, #148]	; (c0de01ac <getEthAddressStringFromBinary+0xd4>)
c0de0116:	4479      	add	r1, pc
c0de0118:	4618      	mov	r0, r3
c0de011a:	f001 f969 	bl	c0de13f0 <strlcat>
        offset = strnlen((char *) locals_union.tmp, sizeof(locals_union.tmp));
c0de011e:	9801      	ldr	r0, [sp, #4]
c0de0120:	4639      	mov	r1, r7
c0de0122:	f001 f9f3 	bl	c0de150c <strnlen>
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
c0de01ac:	000015b9 	.word	0x000015b9
c0de01b0:	0000156e 	.word	0x0000156e

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
c0de01da:	f000 fe65 	bl	c0de0ea8 <__aeabi_uldivmod>
c0de01de:	9005      	str	r0, [sp, #20]
c0de01e0:	9104      	str	r1, [sp, #16]
c0de01e2:	9a03      	ldr	r2, [sp, #12]
c0de01e4:	4633      	mov	r3, r6
c0de01e6:	f000 fe7f 	bl	c0de0ee8 <__aeabi_lmul>
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
c0de0222:	f000 fb97 	bl	c0de0954 <os_longjmp>
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
c0de023c:	f000 fb8a 	bl	c0de0954 <os_longjmp>

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
c0de0264:	f000 fb76 	bl	c0de0954 <os_longjmp>

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
c0de0358:	f000 feec 	bl	c0de1134 <__aeabi_memclr>
    memcpy((uint8_t *) n + INT256_LENGTH - value_len, value, value_len);
c0de035c:	1ba8      	subs	r0, r5, r6
c0de035e:	3020      	adds	r0, #32
c0de0360:	4639      	mov	r1, r7
c0de0362:	4632      	mov	r2, r6
c0de0364:	f000 feec 	bl	c0de1140 <__aeabi_memcpy>
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
c0de03be:	f000 fce7 	bl	c0de0d90 <__udivsi3>
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
c0de03e2:	f001 f839 	bl	c0de1458 <strlcpy>
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
c0de03f8:	f000 fea6 	bl	c0de1148 <__aeabi_memmove>
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
c0de040c:	00001283 	.word	0x00001283

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
c0de0442:	f000 fe77 	bl	c0de1134 <__aeabi_memclr>
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
c0de045e:	f001 f855 	bl	c0de150c <strnlen>
c0de0462:	9001      	str	r0, [sp, #4]
c0de0464:	210b      	movs	r1, #11
    uint8_t ticker_len = strnlen(ticker, MAX_TICKER_LEN);
c0de0466:	9803      	ldr	r0, [sp, #12]
c0de0468:	f001 f850 	bl	c0de150c <strnlen>
c0de046c:	4604      	mov	r4, r0
    memcpy(out_buffer, ticker, MIN(out_buffer_size, ticker_len));
c0de046e:	b2c7      	uxtb	r7, r0
c0de0470:	42b7      	cmp	r7, r6
c0de0472:	4632      	mov	r2, r6
c0de0474:	d800      	bhi.n	c0de0478 <amountToString+0x4a>
c0de0476:	463a      	mov	r2, r7
c0de0478:	4628      	mov	r0, r5
c0de047a:	9903      	ldr	r1, [sp, #12]
c0de047c:	f000 fe60 	bl	c0de1140 <__aeabi_memcpy>
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
c0de04b6:	f000 fa4d 	bl	c0de0954 <os_longjmp>

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
c0de04c6:	f000 fe3f 	bl	c0de1148 <__aeabi_memmove>
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
c0de04d4:	f000 fe38 	bl	c0de1148 <__aeabi_memmove>
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
c0de04e4:	2104      	movs	r1, #4
c0de04e6:	f000 fa55 	bl	c0de0994 <mcu_usb_printf>
c0de04ea:	2063      	movs	r0, #99	; 0x63
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
c0de04fa:	6e40      	ldr	r0, [r0, #100]	; 0x64
c0de04fc:	f000 fbde 	bl	c0de0cbc <pic>
c0de0500:	4601      	mov	r1, r0
c0de0502:	222a      	movs	r2, #42	; 0x2a
c0de0504:	4620      	mov	r0, r4
c0de0506:	f000 fe2b 	bl	c0de1160 <memcmp>
c0de050a:	2800      	cmp	r0, #0
c0de050c:	4630      	mov	r0, r6
c0de050e:	d1f1      	bne.n	c0de04f4 <find_contract_info+0x18>
c0de0510:	19a8      	adds	r0, r5, r6
c0de0512:	3050      	adds	r0, #80	; 0x50
    }
    // when contract is not found
    return NULL;
}
c0de0514:	bd70      	pop	{r4, r5, r6, pc}
c0de0516:	2000      	movs	r0, #0
c0de0518:	bd70      	pop	{r4, r5, r6, pc}
c0de051a:	46c0      	nop			; (mov r8, r8)
c0de051c:	00001228 	.word	0x00001228
c0de0520:	00001318 	.word	0x00001318

c0de0524 <handle_finalize>:

void handle_finalize(void *parameters) {
c0de0524:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de0526:	b085      	sub	sp, #20
c0de0528:	4604      	mov	r4, r0
    ethPluginFinalize_t *msg = (ethPluginFinalize_t *) parameters;
    context_t *context = (context_t *) msg->pluginContext;
c0de052a:	6885      	ldr	r5, [r0, #8]
c0de052c:	2081      	movs	r0, #129	; 0x81

    selector_t selectorIndex = context->selectorIndex;
c0de052e:	5c28      	ldrb	r0, [r5, r0]
    msg->numScreens = selectorIndex == POOL_GET_REWARD || selectorIndex == POOL_EXIT ? 1 : 2;
c0de0530:	1ec0      	subs	r0, r0, #3
c0de0532:	2101      	movs	r1, #1
c0de0534:	2802      	cmp	r0, #2
c0de0536:	9104      	str	r1, [sp, #16]
c0de0538:	4608      	mov	r0, r1
c0de053a:	d300      	bcc.n	c0de053e <handle_finalize+0x1a>
c0de053c:	2002      	movs	r0, #2
c0de053e:	7760      	strb	r0, [r4, #29]
c0de0540:	2020      	movs	r0, #32
c0de0542:	2130      	movs	r1, #48	; 0x30

    // Fill context underlying and vault ticker/decimals
    char *addr = context->contract_address;
    addr[0] = '0';
c0de0544:	5429      	strb	r1, [r5, r0]
c0de0546:	462e      	mov	r6, r5
c0de0548:	3620      	adds	r6, #32
c0de054a:	2078      	movs	r0, #120	; 0x78
    addr[1] = 'x';
c0de054c:	7070      	strb	r0, [r6, #1]

    uint64_t chainId = 0;
    getEthAddressStringFromBinary(msg->pluginSharedRO->txContent->destination,
                                  addr + 2,  // +2 here because we've already prefixed with '0x'.
                                  msg->pluginSharedRW->sha3,
c0de054e:	cc03      	ldmia	r4!, {r0, r1}
c0de0550:	6802      	ldr	r2, [r0, #0]
    getEthAddressStringFromBinary(msg->pluginSharedRO->txContent->destination,
c0de0552:	6808      	ldr	r0, [r1, #0]
c0de0554:	2100      	movs	r1, #0
c0de0556:	9100      	str	r1, [sp, #0]
c0de0558:	9101      	str	r1, [sp, #4]
                                  addr + 2,  // +2 here because we've already prefixed with '0x'.
c0de055a:	1cb1      	adds	r1, r6, #2
    getEthAddressStringFromBinary(msg->pluginSharedRO->txContent->destination,
c0de055c:	30a5      	adds	r0, #165	; 0xa5
                                  msg->pluginSharedRW->sha3,
c0de055e:	3c08      	subs	r4, #8
    getEthAddressStringFromBinary(msg->pluginSharedRO->txContent->destination,
c0de0560:	f7ff fdba 	bl	c0de00d8 <getEthAddressStringFromBinary>
                                  chainId);
    PRINTF("MSG Address: %s\n", addr);
c0de0564:	4816      	ldr	r0, [pc, #88]	; (c0de05c0 <handle_finalize+0x9c>)
c0de0566:	4478      	add	r0, pc
c0de0568:	4631      	mov	r1, r6
c0de056a:	f000 fa13 	bl	c0de0994 <mcu_usb_printf>

    contract_info_t *info = find_contract_info(addr);
c0de056e:	4630      	mov	r0, r6
c0de0570:	f7ff ffb4 	bl	c0de04dc <find_contract_info>
c0de0574:	4607      	mov	r7, r0

    if (info == NULL) {  // if contract info is not found
c0de0576:	2800      	cmp	r0, #0
c0de0578:	9804      	ldr	r0, [sp, #16]
c0de057a:	d01d      	beq.n	c0de05b8 <handle_finalize+0x94>
c0de057c:	4628      	mov	r0, r5
c0de057e:	304b      	adds	r0, #75	; 0x4b
c0de0580:	9004      	str	r0, [sp, #16]
        msg->result = ETH_PLUGIN_RESULT_UNAVAILABLE;

    } else {
        strlcpy(context->underlying_ticker,
                (char *) PIC(info->underlying_ticker),
c0de0582:	6878      	ldr	r0, [r7, #4]
c0de0584:	f000 fb9a 	bl	c0de0cbc <pic>
c0de0588:	4601      	mov	r1, r0
        strlcpy(context->underlying_ticker,
c0de058a:	4628      	mov	r0, r5
c0de058c:	3034      	adds	r0, #52	; 0x34
c0de058e:	220b      	movs	r2, #11
c0de0590:	9203      	str	r2, [sp, #12]
c0de0592:	f000 ff61 	bl	c0de1458 <strlcpy>
                sizeof(context->underlying_ticker));
        context->underlying_decimals = info->underlying_decimals;
c0de0596:	7a38      	ldrb	r0, [r7, #8]
c0de0598:	77f0      	strb	r0, [r6, #31]
        strlcpy(context->vault_ticker,
                (char *) PIC(info->vault_ticker),
c0de059a:	68f8      	ldr	r0, [r7, #12]
c0de059c:	f000 fb8e 	bl	c0de0cbc <pic>
c0de05a0:	4601      	mov	r1, r0
        strlcpy(context->vault_ticker,
c0de05a2:	3540      	adds	r5, #64	; 0x40
c0de05a4:	4628      	mov	r0, r5
c0de05a6:	9a03      	ldr	r2, [sp, #12]
c0de05a8:	f000 ff56 	bl	c0de1458 <strlcpy>
c0de05ac:	2002      	movs	r0, #2
                sizeof(context->vault_ticker));
        context->vault_decimals = info->vault_decimals;

        msg->uiType = ETH_UI_TYPE_GENERIC;
c0de05ae:	7720      	strb	r0, [r4, #28]
        context->vault_decimals = info->vault_decimals;
c0de05b0:	7c38      	ldrb	r0, [r7, #16]
c0de05b2:	9904      	ldr	r1, [sp, #16]
c0de05b4:	7008      	strb	r0, [r1, #0]
c0de05b6:	2004      	movs	r0, #4
        msg->result = ETH_PLUGIN_RESULT_UNAVAILABLE;
c0de05b8:	77a0      	strb	r0, [r4, #30]
        msg->result = ETH_PLUGIN_RESULT_OK;
    }
}
c0de05ba:	b005      	add	sp, #20
c0de05bc:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0de05be:	46c0      	nop			; (mov r8, r8)
c0de05c0:	0000123e 	.word	0x0000123e

c0de05c4 <handle_init_contract>:
    }
    return -1;
}

// Called once to init.
void handle_init_contract(void *parameters) {
c0de05c4:	b570      	push	{r4, r5, r6, lr}
c0de05c6:	4604      	mov	r4, r0
    // Cast the msg to the type of structure we expect (here, ethPluginInitContract_t).
    ethPluginInitContract_t *msg = (ethPluginInitContract_t *) parameters;

    // Make sure we are running a compatible version.
    if (msg->interfaceVersion != ETH_PLUGIN_INTERFACE_VERSION_LATEST) {
c0de05c8:	7800      	ldrb	r0, [r0, #0]
c0de05ca:	2601      	movs	r6, #1
c0de05cc:	2806      	cmp	r0, #6
c0de05ce:	d107      	bne.n	c0de05e0 <handle_init_contract+0x1c>
        return;
    }

    // Double check that the `context_t` struct is not bigger than the maximum size (defined by
    // `msg->pluginContextLength`).
    if (msg->pluginContextLength < sizeof(context_t)) {
c0de05d0:	6920      	ldr	r0, [r4, #16]
c0de05d2:	2881      	cmp	r0, #129	; 0x81
c0de05d4:	d806      	bhi.n	c0de05e4 <handle_init_contract+0x20>
        PRINTF("Plugin parameters structure is bigger than allowed size\n");
c0de05d6:	481d      	ldr	r0, [pc, #116]	; (c0de064c <handle_init_contract+0x88>)
c0de05d8:	4478      	add	r0, pc
c0de05da:	f000 f9db 	bl	c0de0994 <mcu_usb_printf>
c0de05de:	2600      	movs	r6, #0
c0de05e0:	7066      	strb	r6, [r4, #1]
            return;
    }

    // Return valid status.
    msg->result = ETH_PLUGIN_RESULT_OK;
}
c0de05e2:	bd70      	pop	{r4, r5, r6, pc}
    context_t *context = (context_t *) msg->pluginContext;
c0de05e4:	68e5      	ldr	r5, [r4, #12]
c0de05e6:	2182      	movs	r1, #130	; 0x82
    memset(context, 0, sizeof(*context));
c0de05e8:	4628      	mov	r0, r5
c0de05ea:	f000 fda3 	bl	c0de1134 <__aeabi_memclr>
    uint32_t selector = U4BE(msg->selector, 0);
c0de05ee:	6960      	ldr	r0, [r4, #20]
#define U4(hi3, hi2, lo1,lo0) ((((hi3)&0xFFu)<<24) | (((hi2)&0xFFu)<<16) | (((lo1)&0xFFu)<<8) | ((lo0)&0xFFu))
static inline uint16_t U2BE(const uint8_t *buf, size_t off) {
  return (buf[off] << 8) | buf[off + 1];
}
static inline uint32_t U4BE(const uint8_t *buf, size_t off) {
  return (((uint32_t)buf[off]) << 24) | (buf[off + 1] << 16) | (buf[off + 2] << 8) | buf[off + 3];
c0de05f0:	7801      	ldrb	r1, [r0, #0]
c0de05f2:	0609      	lsls	r1, r1, #24
c0de05f4:	7842      	ldrb	r2, [r0, #1]
c0de05f6:	0412      	lsls	r2, r2, #16
c0de05f8:	1851      	adds	r1, r2, r1
c0de05fa:	7882      	ldrb	r2, [r0, #2]
c0de05fc:	0212      	lsls	r2, r2, #8
c0de05fe:	1889      	adds	r1, r1, r2
c0de0600:	78c0      	ldrb	r0, [r0, #3]
c0de0602:	1808      	adds	r0, r1, r0
c0de0604:	3580      	adds	r5, #128	; 0x80
c0de0606:	2100      	movs	r1, #0
c0de0608:	4a11      	ldr	r2, [pc, #68]	; (c0de0650 <handle_init_contract+0x8c>)
c0de060a:	447a      	add	r2, pc
    for (selector_t i = 0; i < n; i++) {
c0de060c:	2906      	cmp	r1, #6
c0de060e:	d0e7      	beq.n	c0de05e0 <handle_init_contract+0x1c>
        if (selector == selectors[i]) {
c0de0610:	6813      	ldr	r3, [r2, #0]
c0de0612:	4283      	cmp	r3, r0
c0de0614:	d002      	beq.n	c0de061c <handle_init_contract+0x58>
    for (selector_t i = 0; i < n; i++) {
c0de0616:	1d12      	adds	r2, r2, #4
c0de0618:	1c49      	adds	r1, r1, #1
c0de061a:	e7f7      	b.n	c0de060c <handle_init_contract+0x48>
            *out = i;
c0de061c:	7069      	strb	r1, [r5, #1]
    if (find_selector(selector, HARVEST_SELECTORS, NUM_SELECTORS, &context->selectorIndex)) {
c0de061e:	2905      	cmp	r1, #5
c0de0620:	d8de      	bhi.n	c0de05e0 <handle_init_contract+0x1c>
            *out = i;
c0de0622:	b2c8      	uxtb	r0, r1
    switch (context->selectorIndex) {
c0de0624:	2803      	cmp	r0, #3
c0de0626:	d308      	bcc.n	c0de063a <handle_init_contract+0x76>
c0de0628:	1ec2      	subs	r2, r0, #3
c0de062a:	2a02      	cmp	r2, #2
c0de062c:	d303      	bcc.n	c0de0636 <handle_init_contract+0x72>
c0de062e:	2805      	cmp	r0, #5
c0de0630:	d107      	bne.n	c0de0642 <handle_init_contract+0x7e>
c0de0632:	200a      	movs	r0, #10
            context->next_param = FROM_ADDRESS;
c0de0634:	7028      	strb	r0, [r5, #0]
c0de0636:	2001      	movs	r0, #1
c0de0638:	e000      	b.n	c0de063c <handle_init_contract+0x78>
c0de063a:	2000      	movs	r0, #0
c0de063c:	7028      	strb	r0, [r5, #0]
c0de063e:	2604      	movs	r6, #4
c0de0640:	e7ce      	b.n	c0de05e0 <handle_init_contract+0x1c>
            PRINTF("Missing selectorIndex: %d\n", context->selectorIndex);
c0de0642:	4804      	ldr	r0, [pc, #16]	; (c0de0654 <handle_init_contract+0x90>)
c0de0644:	4478      	add	r0, pc
c0de0646:	f000 f9a5 	bl	c0de0994 <mcu_usb_printf>
c0de064a:	e7c8      	b.n	c0de05de <handle_init_contract+0x1a>
c0de064c:	00000f78 	.word	0x00000f78
c0de0650:	00000f2a 	.word	0x00000f2a
c0de0654:	00001179 	.word	0x00001179

c0de0658 <handle_provide_parameter>:
            msg->result = ETH_PLUGIN_RESULT_ERROR;
            break;
    }
}

void handle_provide_parameter(void *parameters) {
c0de0658:	b5f8      	push	{r3, r4, r5, r6, r7, lr}
c0de065a:	4604      	mov	r4, r0
    ethPluginProvideParameter_t *msg = (ethPluginProvideParameter_t *) parameters;
    context_t *context = (context_t *) msg->pluginContext;
c0de065c:	6885      	ldr	r5, [r0, #8]
    // the number of bytes you wish to print (in this case, `PARAMETER_LENGTH`) and then
    // the address (here `msg->parameter`).
    PRINTF("plugin provide parameter: offset %d\nBytes: %.*H\n",
           msg->parameterOffset,
           PARAMETER_LENGTH,
           msg->parameter);
c0de065e:	68c3      	ldr	r3, [r0, #12]
           msg->parameterOffset,
c0de0660:	6901      	ldr	r1, [r0, #16]
    PRINTF("plugin provide parameter: offset %d\nBytes: %.*H\n",
c0de0662:	482b      	ldr	r0, [pc, #172]	; (c0de0710 <handle_provide_parameter+0xb8>)
c0de0664:	4478      	add	r0, pc
c0de0666:	2220      	movs	r2, #32
c0de0668:	f000 f994 	bl	c0de0994 <mcu_usb_printf>
c0de066c:	2004      	movs	r0, #4

    msg->result = ETH_PLUGIN_RESULT_OK;
c0de066e:	7520      	strb	r0, [r4, #20]
c0de0670:	2081      	movs	r0, #129	; 0x81

    switch (context->selectorIndex) {
c0de0672:	5c28      	ldrb	r0, [r5, r0]
c0de0674:	462e      	mov	r6, r5
c0de0676:	3680      	adds	r6, #128	; 0x80
c0de0678:	2803      	cmp	r0, #3
c0de067a:	d205      	bcs.n	c0de0688 <handle_provide_parameter+0x30>
    switch (context->next_param) {
c0de067c:	7831      	ldrb	r1, [r6, #0]
c0de067e:	2900      	cmp	r1, #0
c0de0680:	d021      	beq.n	c0de06c6 <handle_provide_parameter+0x6e>
            PRINTF("Param not supported: %d\n", context->next_param);
c0de0682:	4826      	ldr	r0, [pc, #152]	; (c0de071c <handle_provide_parameter+0xc4>)
c0de0684:	4478      	add	r0, pc
c0de0686:	e03e      	b.n	c0de0706 <handle_provide_parameter+0xae>
    switch (context->selectorIndex) {
c0de0688:	2805      	cmp	r0, #5
c0de068a:	d139      	bne.n	c0de0700 <handle_provide_parameter+0xa8>
    switch (context->next_param) {
c0de068c:	7831      	ldrb	r1, [r6, #0]
c0de068e:	290b      	cmp	r1, #11
c0de0690:	d021      	beq.n	c0de06d6 <handle_provide_parameter+0x7e>
c0de0692:	290a      	cmp	r1, #10
c0de0694:	d128      	bne.n	c0de06e8 <handle_provide_parameter+0x90>
            copy_address(context->from_address, msg->parameter, sizeof(context->from_address));
c0de0696:	68e1      	ldr	r1, [r4, #12]
c0de0698:	4628      	mov	r0, r5
c0de069a:	304c      	adds	r0, #76	; 0x4c
c0de069c:	2214      	movs	r2, #20
c0de069e:	f7ff ff0c 	bl	c0de04ba <copy_address>
c0de06a2:	200b      	movs	r0, #11
c0de06a4:	9600      	str	r6, [sp, #0]
            context->next_param = FROM_AMOUNT;
c0de06a6:	7030      	strb	r0, [r6, #0]
} contract_info_t;

static inline void printf_hex_array(const char *title __attribute__((unused)),
                                    size_t len __attribute__((unused)),
                                    const uint8_t *data __attribute__((unused))) {
    PRINTF(title);
c0de06a8:	481a      	ldr	r0, [pc, #104]	; (c0de0714 <handle_provide_parameter+0xbc>)
c0de06aa:	4478      	add	r0, pc
c0de06ac:	f000 f972 	bl	c0de0994 <mcu_usb_printf>
c0de06b0:	274c      	movs	r7, #76	; 0x4c
c0de06b2:	4e19      	ldr	r6, [pc, #100]	; (c0de0718 <handle_provide_parameter+0xc0>)
c0de06b4:	447e      	add	r6, pc
    for (size_t i = 0; i < len; ++i) {
c0de06b6:	2f60      	cmp	r7, #96	; 0x60
c0de06b8:	d01d      	beq.n	c0de06f6 <handle_provide_parameter+0x9e>
        PRINTF("%02x", data[i]);
c0de06ba:	5de9      	ldrb	r1, [r5, r7]
c0de06bc:	4630      	mov	r0, r6
c0de06be:	f000 f969 	bl	c0de0994 <mcu_usb_printf>
    for (size_t i = 0; i < len; ++i) {
c0de06c2:	1c7f      	adds	r7, r7, #1
c0de06c4:	e7f7      	b.n	c0de06b6 <handle_provide_parameter+0x5e>
            copy_parameter(context->amount, msg->parameter, sizeof(context->amount));
c0de06c6:	68e1      	ldr	r1, [r4, #12]
c0de06c8:	2220      	movs	r2, #32
c0de06ca:	4628      	mov	r0, r5
c0de06cc:	f7ff fefe 	bl	c0de04cc <copy_parameter>
c0de06d0:	2001      	movs	r0, #1
            context->next_param = UNEXPECTED_PARAMETER;
c0de06d2:	7030      	strb	r0, [r6, #0]
        default:
            PRINTF("Selector Index not supported: %d\n", context->selectorIndex);
            msg->result = ETH_PLUGIN_RESULT_ERROR;
            break;
    }
}
c0de06d4:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
            copy_parameter(context->from_amount, msg->parameter, sizeof(context->from_amount));
c0de06d6:	68e1      	ldr	r1, [r4, #12]
c0de06d8:	3560      	adds	r5, #96	; 0x60
c0de06da:	2220      	movs	r2, #32
c0de06dc:	4628      	mov	r0, r5
c0de06de:	f7ff fef5 	bl	c0de04cc <copy_parameter>
c0de06e2:	2001      	movs	r0, #1
            context->next_param = UNEXPECTED_PARAMETER;
c0de06e4:	7030      	strb	r0, [r6, #0]
c0de06e6:	e00b      	b.n	c0de0700 <handle_provide_parameter+0xa8>
            PRINTF("Param not supported: %d\n", context->next_param);
c0de06e8:	480e      	ldr	r0, [pc, #56]	; (c0de0724 <handle_provide_parameter+0xcc>)
c0de06ea:	4478      	add	r0, pc
c0de06ec:	f000 f952 	bl	c0de0994 <mcu_usb_printf>
c0de06f0:	2000      	movs	r0, #0
            msg->result = ETH_PLUGIN_RESULT_ERROR;
c0de06f2:	7520      	strb	r0, [r4, #20]
c0de06f4:	e004      	b.n	c0de0700 <handle_provide_parameter+0xa8>
    };
    PRINTF("\n");
c0de06f6:	480a      	ldr	r0, [pc, #40]	; (c0de0720 <handle_provide_parameter+0xc8>)
c0de06f8:	4478      	add	r0, pc
c0de06fa:	f000 f94b 	bl	c0de0994 <mcu_usb_printf>
c0de06fe:	9e00      	ldr	r6, [sp, #0]
            PRINTF("Selector Index not supported: %d\n", context->selectorIndex);
c0de0700:	7871      	ldrb	r1, [r6, #1]
c0de0702:	4809      	ldr	r0, [pc, #36]	; (c0de0728 <handle_provide_parameter+0xd0>)
c0de0704:	4478      	add	r0, pc
c0de0706:	f000 f945 	bl	c0de0994 <mcu_usb_printf>
c0de070a:	2000      	movs	r0, #0
c0de070c:	7520      	strb	r0, [r4, #20]
}
c0de070e:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
c0de0710:	00001105 	.word	0x00001105
c0de0714:	00001083 	.word	0x00001083
c0de0718:	00000f86 	.word	0x00000f86
c0de071c:	00000fdf 	.word	0x00000fdf
c0de0720:	0000102d 	.word	0x0000102d
c0de0724:	00000f79 	.word	0x00000f79
c0de0728:	00000fce 	.word	0x00000fce

c0de072c <handle_provide_token>:
#include "harvest_plugin.h"

void handle_provide_token(void *parameters) {
c0de072c:	2104      	movs	r1, #4
    ethPluginProvideInfo_t *msg = (ethPluginProvideInfo_t *) parameters;
    msg->result = ETH_PLUGIN_RESULT_OK;
c0de072e:	7541      	strb	r1, [r0, #21]
}
c0de0730:	4770      	bx	lr

c0de0732 <set_msg>:
#include "harvest_plugin.h"

void set_msg(ethQueryContractID_t *msg, char *text) {
c0de0732:	b580      	push	{r7, lr}
    strlcpy(msg->version, text, msg->versionLength);
c0de0734:	6943      	ldr	r3, [r0, #20]
c0de0736:	6982      	ldr	r2, [r0, #24]
c0de0738:	4618      	mov	r0, r3
c0de073a:	f000 fe8d 	bl	c0de1458 <strlcpy>
}
c0de073e:	bd80      	pop	{r7, pc}

c0de0740 <handle_query_contract_id>:

// Sets the first screen to display.
void handle_query_contract_id(void *parameters) {
c0de0740:	b5b0      	push	{r4, r5, r7, lr}
c0de0742:	4604      	mov	r4, r0
    ethQueryContractID_t *msg = (ethQueryContractID_t *) parameters;
    const context_t *context = (const context_t *) msg->pluginContext;
c0de0744:	6885      	ldr	r5, [r0, #8]
    // msg->name will be the upper sentence displayed on the screen.
    // msg->version will be the lower sentence displayed on the screen.

    // For the first screen, display the plugin name.
    strlcpy(msg->name, PLUGIN_NAME, msg->nameLength);
c0de0746:	68c0      	ldr	r0, [r0, #12]
c0de0748:	6922      	ldr	r2, [r4, #16]
c0de074a:	4918      	ldr	r1, [pc, #96]	; (c0de07ac <handle_query_contract_id+0x6c>)
c0de074c:	4479      	add	r1, pc
c0de074e:	f000 fe83 	bl	c0de1458 <strlcpy>
c0de0752:	2004      	movs	r0, #4

    msg->result = ETH_PLUGIN_RESULT_OK;
c0de0754:	7720      	strb	r0, [r4, #28]
c0de0756:	2081      	movs	r0, #129	; 0x81
    selector_t selectorIndex = context->selectorIndex;
c0de0758:	5c29      	ldrb	r1, [r5, r0]

    switch (selectorIndex) {
c0de075a:	2905      	cmp	r1, #5
c0de075c:	d00c      	beq.n	c0de0778 <handle_query_contract_id+0x38>
c0de075e:	2901      	cmp	r1, #1
c0de0760:	d00d      	beq.n	c0de077e <handle_query_contract_id+0x3e>
c0de0762:	2902      	cmp	r1, #2
c0de0764:	d00e      	beq.n	c0de0784 <handle_query_contract_id+0x44>
c0de0766:	2903      	cmp	r1, #3
c0de0768:	d00f      	beq.n	c0de078a <handle_query_contract_id+0x4a>
c0de076a:	2904      	cmp	r1, #4
c0de076c:	d010      	beq.n	c0de0790 <handle_query_contract_id+0x50>
c0de076e:	2900      	cmp	r1, #0
c0de0770:	d114      	bne.n	c0de079c <handle_query_contract_id+0x5c>
        case VAULT_DEPOSIT:
            set_msg(msg, "Deposit");
c0de0772:	490f      	ldr	r1, [pc, #60]	; (c0de07b0 <handle_query_contract_id+0x70>)
c0de0774:	4479      	add	r1, pc
c0de0776:	e00d      	b.n	c0de0794 <handle_query_contract_id+0x54>
            break;
        case POOL_GET_REWARD:
            set_msg(msg, "Claim");
            break;
        case WIDO_EXECUTE_ORDER:
            set_msg(msg, "Wido Execute");
c0de0778:	4912      	ldr	r1, [pc, #72]	; (c0de07c4 <handle_query_contract_id+0x84>)
c0de077a:	4479      	add	r1, pc
c0de077c:	e00a      	b.n	c0de0794 <handle_query_contract_id+0x54>
            set_msg(msg, "Withdraw");
c0de077e:	490d      	ldr	r1, [pc, #52]	; (c0de07b4 <handle_query_contract_id+0x74>)
c0de0780:	4479      	add	r1, pc
c0de0782:	e007      	b.n	c0de0794 <handle_query_contract_id+0x54>
            set_msg(msg, "Stake");
c0de0784:	490c      	ldr	r1, [pc, #48]	; (c0de07b8 <handle_query_contract_id+0x78>)
c0de0786:	4479      	add	r1, pc
c0de0788:	e004      	b.n	c0de0794 <handle_query_contract_id+0x54>
            set_msg(msg, "Claim");
c0de078a:	490d      	ldr	r1, [pc, #52]	; (c0de07c0 <handle_query_contract_id+0x80>)
c0de078c:	4479      	add	r1, pc
c0de078e:	e001      	b.n	c0de0794 <handle_query_contract_id+0x54>
            set_msg(msg, "Exit");
c0de0790:	490a      	ldr	r1, [pc, #40]	; (c0de07bc <handle_query_contract_id+0x7c>)
c0de0792:	4479      	add	r1, pc
c0de0794:	4620      	mov	r0, r4
c0de0796:	f7ff ffcc 	bl	c0de0732 <set_msg>
        default:
            PRINTF("Selector index: %d not supported\n", selectorIndex);
            msg->result = ETH_PLUGIN_RESULT_ERROR;
            break;
    }
}
c0de079a:	bdb0      	pop	{r4, r5, r7, pc}
            PRINTF("Selector index: %d not supported\n", selectorIndex);
c0de079c:	480a      	ldr	r0, [pc, #40]	; (c0de07c8 <handle_query_contract_id+0x88>)
c0de079e:	4478      	add	r0, pc
c0de07a0:	f000 f8f8 	bl	c0de0994 <mcu_usb_printf>
c0de07a4:	2000      	movs	r0, #0
            msg->result = ETH_PLUGIN_RESULT_ERROR;
c0de07a6:	7720      	strb	r0, [r4, #28]
}
c0de07a8:	bdb0      	pop	{r4, r5, r7, pc}
c0de07aa:	46c0      	nop			; (mov r8, r8)
c0de07ac:	00000ef3 	.word	0x00000ef3
c0de07b0:	00001041 	.word	0x00001041
c0de07b4:	0000101a 	.word	0x0000101a
c0de07b8:	00000ef6 	.word	0x00000ef6
c0de07bc:	00000f07 	.word	0x00000f07
c0de07c0:	00000ecf 	.word	0x00000ecf
c0de07c4:	00000fc1 	.word	0x00000fc1
c0de07c8:	00000e16 	.word	0x00000e16

c0de07cc <handle_query_contract_ui>:
                                  m + 2,  // +2 here because we've already prefixed with '0x'.
                                  msg->pluginSharedRW->sha3,
                                  chainId);
}

void handle_query_contract_ui(void *parameters) {
c0de07cc:	b5fe      	push	{r1, r2, r3, r4, r5, r6, r7, lr}
c0de07ce:	4604      	mov	r4, r0
    ethQueryContractUI_t *msg = (ethQueryContractUI_t *) parameters;
    context_t *context = (context_t *) msg->pluginContext;
c0de07d0:	69c7      	ldr	r7, [r0, #28]

    // msg->title is the upper line displayed on the device.
    // msg->msg is the lower line displayed on the device.

    // Clean the display fields.
    memset(msg->title, 0, msg->titleLength);
c0de07d2:	6a40      	ldr	r0, [r0, #36]	; 0x24
c0de07d4:	6aa1      	ldr	r1, [r4, #40]	; 0x28
c0de07d6:	f000 fcad 	bl	c0de1134 <__aeabi_memclr>
    memset(msg->msg, 0, msg->msgLength);
c0de07da:	6ae0      	ldr	r0, [r4, #44]	; 0x2c
c0de07dc:	6b21      	ldr	r1, [r4, #48]	; 0x30
c0de07de:	f000 fca9 	bl	c0de1134 <__aeabi_memclr>
c0de07e2:	4626      	mov	r6, r4
c0de07e4:	3620      	adds	r6, #32
c0de07e6:	2004      	movs	r0, #4

    msg->result = ETH_PLUGIN_RESULT_OK;
c0de07e8:	7530      	strb	r0, [r6, #20]
c0de07ea:	2020      	movs	r0, #32

    switch (msg->screenIndex) {
c0de07ec:	5c20      	ldrb	r0, [r4, r0]
c0de07ee:	463d      	mov	r5, r7
c0de07f0:	3581      	adds	r5, #129	; 0x81
c0de07f2:	2801      	cmp	r0, #1
c0de07f4:	d007      	beq.n	c0de0806 <handle_query_contract_ui+0x3a>
c0de07f6:	2800      	cmp	r0, #0
c0de07f8:	d119      	bne.n	c0de082e <handle_query_contract_ui+0x62>
    switch (context->selectorIndex) {
c0de07fa:	7828      	ldrb	r0, [r5, #0]
c0de07fc:	2802      	cmp	r0, #2
c0de07fe:	d21b      	bcs.n	c0de0838 <handle_query_contract_ui+0x6c>
c0de0800:	4927      	ldr	r1, [pc, #156]	; (c0de08a0 <handle_query_contract_ui+0xd4>)
c0de0802:	4479      	add	r1, pc
c0de0804:	e022      	b.n	c0de084c <handle_query_contract_ui+0x80>
c0de0806:	4638      	mov	r0, r7
c0de0808:	303f      	adds	r0, #63	; 0x3f
c0de080a:	9002      	str	r0, [sp, #8]
    strlcpy(msg->title, "Amount", msg->titleLength);
c0de080c:	6a60      	ldr	r0, [r4, #36]	; 0x24
c0de080e:	6aa2      	ldr	r2, [r4, #40]	; 0x28
c0de0810:	4926      	ldr	r1, [pc, #152]	; (c0de08ac <handle_query_contract_ui+0xe0>)
c0de0812:	4479      	add	r1, pc
c0de0814:	f000 fe20 	bl	c0de1458 <strlcpy>
    switch (context->selectorIndex) {
c0de0818:	7829      	ldrb	r1, [r5, #0]
c0de081a:	2902      	cmp	r1, #2
c0de081c:	d003      	beq.n	c0de0826 <handle_query_contract_ui+0x5a>
c0de081e:	2901      	cmp	r1, #1
c0de0820:	d028      	beq.n	c0de0874 <handle_query_contract_ui+0xa8>
c0de0822:	2900      	cmp	r1, #0
c0de0824:	d134      	bne.n	c0de0890 <handle_query_contract_ui+0xc4>
            ticker = context->underlying_ticker;
c0de0826:	463b      	mov	r3, r7
c0de0828:	3334      	adds	r3, #52	; 0x34
c0de082a:	9802      	ldr	r0, [sp, #8]
c0de082c:	e026      	b.n	c0de087c <handle_query_contract_ui+0xb0>
        case 1:
            set_amount(msg, context);
            break;
        // Keep this
        default:
            PRINTF("Received an invalid screenIndex\n");
c0de082e:	4821      	ldr	r0, [pc, #132]	; (c0de08b4 <handle_query_contract_ui+0xe8>)
c0de0830:	4478      	add	r0, pc
c0de0832:	f000 f8af 	bl	c0de0994 <mcu_usb_printf>
c0de0836:	e02f      	b.n	c0de0898 <handle_query_contract_ui+0xcc>
    switch (context->selectorIndex) {
c0de0838:	2805      	cmp	r0, #5
c0de083a:	d105      	bne.n	c0de0848 <handle_query_contract_ui+0x7c>
            strlcpy(msg->title, "Wido", msg->titleLength);
c0de083c:	6a60      	ldr	r0, [r4, #36]	; 0x24
c0de083e:	6aa2      	ldr	r2, [r4, #40]	; 0x28
c0de0840:	4918      	ldr	r1, [pc, #96]	; (c0de08a4 <handle_query_contract_ui+0xd8>)
c0de0842:	4479      	add	r1, pc
c0de0844:	f000 fe08 	bl	c0de1458 <strlcpy>
c0de0848:	4917      	ldr	r1, [pc, #92]	; (c0de08a8 <handle_query_contract_ui+0xdc>)
c0de084a:	4479      	add	r1, pc
c0de084c:	6a60      	ldr	r0, [r4, #36]	; 0x24
c0de084e:	6aa2      	ldr	r2, [r4, #40]	; 0x28
c0de0850:	f000 fe02 	bl	c0de1458 <strlcpy>
    char *m = msg->msg;
c0de0854:	6ae1      	ldr	r1, [r4, #44]	; 0x2c
c0de0856:	2030      	movs	r0, #48	; 0x30
    m[0] = '0';
c0de0858:	7008      	strb	r0, [r1, #0]
c0de085a:	2078      	movs	r0, #120	; 0x78
    m[1] = 'x';
c0de085c:	7048      	strb	r0, [r1, #1]
                                  msg->pluginSharedRW->sha3,
c0de085e:	cc09      	ldmia	r4!, {r0, r3}
c0de0860:	6802      	ldr	r2, [r0, #0]
    getEthAddressStringFromBinary(msg->pluginSharedRO->txContent->destination,
c0de0862:	6818      	ldr	r0, [r3, #0]
c0de0864:	2300      	movs	r3, #0
c0de0866:	9300      	str	r3, [sp, #0]
c0de0868:	9301      	str	r3, [sp, #4]
                                  m + 2,  // +2 here because we've already prefixed with '0x'.
c0de086a:	1c89      	adds	r1, r1, #2
    getEthAddressStringFromBinary(msg->pluginSharedRO->txContent->destination,
c0de086c:	30a5      	adds	r0, #165	; 0xa5
c0de086e:	f7ff fc33 	bl	c0de00d8 <getEthAddressStringFromBinary>
            msg->result = ETH_PLUGIN_RESULT_ERROR;
            return;
    }
}
c0de0872:	bdfe      	pop	{r1, r2, r3, r4, r5, r6, r7, pc}
            ticker = context->vault_ticker;
c0de0874:	463b      	mov	r3, r7
c0de0876:	3340      	adds	r3, #64	; 0x40
c0de0878:	9802      	ldr	r0, [sp, #8]
            decimals = context->vault_decimals;
c0de087a:	300c      	adds	r0, #12
c0de087c:	7802      	ldrb	r2, [r0, #0]
                   msg->msg,
c0de087e:	6ae0      	ldr	r0, [r4, #44]	; 0x2c
                   msg->msgLength);
c0de0880:	6b21      	ldr	r1, [r4, #48]	; 0x30
    amountToString(context->amount,
c0de0882:	9000      	str	r0, [sp, #0]
c0de0884:	9101      	str	r1, [sp, #4]
c0de0886:	2120      	movs	r1, #32
c0de0888:	4638      	mov	r0, r7
c0de088a:	f7ff fdd0 	bl	c0de042e <amountToString>
}
c0de088e:	bdfe      	pop	{r1, r2, r3, r4, r5, r6, r7, pc}
            PRINTF("Selector Index not supported: %d\n", context->selectorIndex);
c0de0890:	4807      	ldr	r0, [pc, #28]	; (c0de08b0 <handle_query_contract_ui+0xe4>)
c0de0892:	4478      	add	r0, pc
c0de0894:	f000 f87e 	bl	c0de0994 <mcu_usb_printf>
c0de0898:	2000      	movs	r0, #0
c0de089a:	7530      	strb	r0, [r6, #20]
}
c0de089c:	bdfe      	pop	{r1, r2, r3, r4, r5, r6, r7, pc}
c0de089e:	46c0      	nop			; (mov r8, r8)
c0de08a0:	00000e45 	.word	0x00000e45
c0de08a4:	00000f96 	.word	0x00000f96
c0de08a8:	00000db7 	.word	0x00000db7
c0de08ac:	00000df4 	.word	0x00000df4
c0de08b0:	00000e40 	.word	0x00000e40
c0de08b4:	00000f18 	.word	0x00000f18

c0de08b8 <dispatch_plugin_calls>:
void dispatch_plugin_calls(int message, void *parameters) {
c0de08b8:	b580      	push	{r7, lr}
c0de08ba:	4602      	mov	r2, r0
c0de08bc:	2083      	movs	r0, #131	; 0x83
c0de08be:	0040      	lsls	r0, r0, #1
    switch (message) {
c0de08c0:	4282      	cmp	r2, r0
c0de08c2:	d017      	beq.n	c0de08f4 <dispatch_plugin_calls+0x3c>
c0de08c4:	2081      	movs	r0, #129	; 0x81
c0de08c6:	0040      	lsls	r0, r0, #1
c0de08c8:	4282      	cmp	r2, r0
c0de08ca:	d017      	beq.n	c0de08fc <dispatch_plugin_calls+0x44>
c0de08cc:	20ff      	movs	r0, #255	; 0xff
c0de08ce:	4603      	mov	r3, r0
c0de08d0:	3304      	adds	r3, #4
c0de08d2:	429a      	cmp	r2, r3
c0de08d4:	d016      	beq.n	c0de0904 <dispatch_plugin_calls+0x4c>
c0de08d6:	2341      	movs	r3, #65	; 0x41
c0de08d8:	009b      	lsls	r3, r3, #2
c0de08da:	429a      	cmp	r2, r3
c0de08dc:	d016      	beq.n	c0de090c <dispatch_plugin_calls+0x54>
c0de08de:	4603      	mov	r3, r0
c0de08e0:	3306      	adds	r3, #6
c0de08e2:	429a      	cmp	r2, r3
c0de08e4:	d016      	beq.n	c0de0914 <dispatch_plugin_calls+0x5c>
c0de08e6:	3002      	adds	r0, #2
c0de08e8:	4282      	cmp	r2, r0
c0de08ea:	d117      	bne.n	c0de091c <dispatch_plugin_calls+0x64>
            handle_init_contract(parameters);
c0de08ec:	4608      	mov	r0, r1
c0de08ee:	f7ff fe69 	bl	c0de05c4 <handle_init_contract>
}
c0de08f2:	bd80      	pop	{r7, pc}
            handle_query_contract_ui(parameters);
c0de08f4:	4608      	mov	r0, r1
c0de08f6:	f7ff ff69 	bl	c0de07cc <handle_query_contract_ui>
}
c0de08fa:	bd80      	pop	{r7, pc}
            handle_provide_parameter(parameters);
c0de08fc:	4608      	mov	r0, r1
c0de08fe:	f7ff feab 	bl	c0de0658 <handle_provide_parameter>
}
c0de0902:	bd80      	pop	{r7, pc}
            handle_finalize(parameters);
c0de0904:	4608      	mov	r0, r1
c0de0906:	f7ff fe0d 	bl	c0de0524 <handle_finalize>
}
c0de090a:	bd80      	pop	{r7, pc}
            handle_provide_token(parameters);
c0de090c:	4608      	mov	r0, r1
c0de090e:	f7ff ff0d 	bl	c0de072c <handle_provide_token>
}
c0de0912:	bd80      	pop	{r7, pc}
            handle_query_contract_id(parameters);
c0de0914:	4608      	mov	r0, r1
c0de0916:	f7ff ff13 	bl	c0de0740 <handle_query_contract_id>
}
c0de091a:	bd80      	pop	{r7, pc}
            PRINTF("Unhandled message %d\n", message);
c0de091c:	4802      	ldr	r0, [pc, #8]	; (c0de0928 <dispatch_plugin_calls+0x70>)
c0de091e:	4478      	add	r0, pc
c0de0920:	4611      	mov	r1, r2
c0de0922:	f000 f837 	bl	c0de0994 <mcu_usb_printf>
}
c0de0926:	bd80      	pop	{r7, pc}
c0de0928:	00000dd6 	.word	0x00000dd6

c0de092c <call_app_ethereum>:
void call_app_ethereum() {
c0de092c:	b5f8      	push	{r3, r4, r5, r6, r7, lr}
    libcall_params[0] = (unsigned int) "Ethereum";
c0de092e:	4805      	ldr	r0, [pc, #20]	; (c0de0944 <call_app_ethereum+0x18>)
c0de0930:	4478      	add	r0, pc
c0de0932:	9001      	str	r0, [sp, #4]
c0de0934:	2001      	movs	r0, #1
    libcall_params[2] = RUN_APPLICATION;
c0de0936:	9003      	str	r0, [sp, #12]
c0de0938:	0200      	lsls	r0, r0, #8
    libcall_params[1] = 0x100;
c0de093a:	9002      	str	r0, [sp, #8]
c0de093c:	a801      	add	r0, sp, #4
    os_lib_call((unsigned int *) &libcall_params);
c0de093e:	f000 f9e9 	bl	c0de0d14 <os_lib_call>
}
c0de0942:	bd8f      	pop	{r0, r1, r2, r3, r7, pc}
c0de0944:	00000d22 	.word	0x00000d22

c0de0948 <os_boot>:

// apdu buffer must hold a complete apdu to avoid troubles
unsigned char G_io_apdu_buffer[IO_APDU_BUFFER_SIZE];

#ifndef BOLOS_OS_UPGRADER_APP
void os_boot(void) {
c0de0948:	b580      	push	{r7, lr}
c0de094a:	2000      	movs	r0, #0
  // // TODO patch entry point when romming (f)
  // // set the default try context to nothing
#ifndef HAVE_BOLOS
  try_context_set(NULL);
c0de094c:	f000 fa14 	bl	c0de0d78 <try_context_set>
#endif // HAVE_BOLOS
}
c0de0950:	bd80      	pop	{r7, pc}
c0de0952:	d4d4      	bmi.n	c0de08fe <dispatch_plugin_calls+0x46>

c0de0954 <os_longjmp>:
  }
  return xoracc;
}

#ifndef HAVE_BOLOS
void os_longjmp(unsigned int exception) {
c0de0954:	4604      	mov	r4, r0
#ifdef HAVE_PRINTF
  unsigned int lr_val;
  __asm volatile("mov %0, lr" :"=r"(lr_val));
c0de0956:	4672      	mov	r2, lr
  PRINTF("exception[%d]: LR=0x%08X\n", exception, lr_val);
c0de0958:	4804      	ldr	r0, [pc, #16]	; (c0de096c <os_longjmp+0x18>)
c0de095a:	4478      	add	r0, pc
c0de095c:	4621      	mov	r1, r4
c0de095e:	f000 f819 	bl	c0de0994 <mcu_usb_printf>
#endif // HAVE_PRINTF
  longjmp(try_context_get()->jmp_buf, exception);
c0de0962:	f000 fa01 	bl	c0de0d68 <try_context_get>
c0de0966:	4621      	mov	r1, r4
c0de0968:	f000 fd34 	bl	c0de13d4 <longjmp>
c0de096c:	00000d55 	.word	0x00000d55

c0de0970 <mcu_usb_prints>:
  return ret;
}
#endif // !defined(APP_UX)

#ifdef HAVE_PRINTF
void mcu_usb_prints(const char* str, unsigned int charcount) {
c0de0970:	b5bc      	push	{r2, r3, r4, r5, r7, lr}
c0de0972:	460c      	mov	r4, r1
c0de0974:	4605      	mov	r5, r0
c0de0976:	a801      	add	r0, sp, #4
  buf[0] = SEPROXYHAL_TAG_PRINTF_STATUS;
#else
  buf[0] = SEPROXYHAL_TAG_PRINTF;
#endif
  buf[1] = charcount >> 8;
  buf[2] = charcount;
c0de0978:	7081      	strb	r1, [r0, #2]
c0de097a:	215f      	movs	r1, #95	; 0x5f
  buf[0] = SEPROXYHAL_TAG_PRINTF;
c0de097c:	7001      	strb	r1, [r0, #0]
  buf[1] = charcount >> 8;
c0de097e:	0a21      	lsrs	r1, r4, #8
c0de0980:	7041      	strb	r1, [r0, #1]
c0de0982:	2103      	movs	r1, #3
  io_seproxyhal_spi_send(buf, 3);
c0de0984:	f000 f9e6 	bl	c0de0d54 <io_seph_send>
  io_seproxyhal_spi_send((const uint8_t *) str, charcount);
c0de0988:	b2a1      	uxth	r1, r4
c0de098a:	4628      	mov	r0, r5
c0de098c:	f000 f9e2 	bl	c0de0d54 <io_seph_send>
}
c0de0990:	bdbc      	pop	{r2, r3, r4, r5, r7, pc}
c0de0992:	d4d4      	bmi.n	c0de093e <call_app_ethereum+0x12>

c0de0994 <mcu_usb_printf>:
#ifdef HAVE_PRINTF
#include "os_io_seproxyhal.h"

void screen_printf(const char* format, ...) __attribute__ ((weak, alias ("mcu_usb_printf")));

void mcu_usb_printf(const char* format, ...) {
c0de0994:	b083      	sub	sp, #12
c0de0996:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de0998:	b08e      	sub	sp, #56	; 0x38
c0de099a:	ac13      	add	r4, sp, #76	; 0x4c
c0de099c:	c40e      	stmia	r4!, {r1, r2, r3}
    char cStrlenSet;

    //
    // Check the arguments.
    //
    if(format == 0) {
c0de099e:	2800      	cmp	r0, #0
c0de09a0:	d100      	bne.n	c0de09a4 <mcu_usb_printf+0x10>
c0de09a2:	e16f      	b.n	c0de0c84 <mcu_usb_printf+0x2f0>
c0de09a4:	4607      	mov	r7, r0
c0de09a6:	a813      	add	r0, sp, #76	; 0x4c
    }

    //
    // Start the varargs processing.
    //
    va_start(vaArgP, format);
c0de09a8:	9008      	str	r0, [sp, #32]
c0de09aa:	2001      	movs	r0, #1
c0de09ac:	9002      	str	r0, [sp, #8]

    //
    // Loop while there are more characters in the string.
    //
    while(*format)
c0de09ae:	7838      	ldrb	r0, [r7, #0]
c0de09b0:	2800      	cmp	r0, #0
c0de09b2:	d100      	bne.n	c0de09b6 <mcu_usb_printf+0x22>
c0de09b4:	e166      	b.n	c0de0c84 <mcu_usb_printf+0x2f0>
c0de09b6:	463c      	mov	r4, r7
c0de09b8:	2500      	movs	r5, #0
    {
        //
        // Find the first non-% character, or the end of the string.
        //
        for(ulIdx = 0; (format[ulIdx] != '%') && (format[ulIdx] != '\0');
c0de09ba:	2800      	cmp	r0, #0
c0de09bc:	d005      	beq.n	c0de09ca <mcu_usb_printf+0x36>
c0de09be:	2825      	cmp	r0, #37	; 0x25
c0de09c0:	d003      	beq.n	c0de09ca <mcu_usb_printf+0x36>
c0de09c2:	1960      	adds	r0, r4, r5
c0de09c4:	7840      	ldrb	r0, [r0, #1]
            ulIdx++)
c0de09c6:	1c6d      	adds	r5, r5, #1
c0de09c8:	e7f7      	b.n	c0de09ba <mcu_usb_printf+0x26>
        }

        //
        // Write this portion of the string.
        //
        mcu_usb_prints(format, ulIdx);
c0de09ca:	4620      	mov	r0, r4
c0de09cc:	4629      	mov	r1, r5
c0de09ce:	f7ff ffcf 	bl	c0de0970 <mcu_usb_prints>
c0de09d2:	1967      	adds	r7, r4, r5
        format += ulIdx;

        //
        // See if the next character is a %.
        //
        if(*format == '%')
c0de09d4:	5d60      	ldrb	r0, [r4, r5]
c0de09d6:	2825      	cmp	r0, #37	; 0x25
c0de09d8:	d1e9      	bne.n	c0de09ae <mcu_usb_printf+0x1a>
            ulCount = 0;
            cFill = ' ';
            ulStrlen = 0;
            cStrlenSet = 0;
            ulCap = 0;
            ulBase = 10;
c0de09da:	1960      	adds	r0, r4, r5
c0de09dc:	1c47      	adds	r7, r0, #1
c0de09de:	2400      	movs	r4, #0
c0de09e0:	2320      	movs	r3, #32
c0de09e2:	9407      	str	r4, [sp, #28]
c0de09e4:	4622      	mov	r2, r4
c0de09e6:	4610      	mov	r0, r2
again:

            //
            // Determine how to handle the next character.
            //
            switch(*format++)
c0de09e8:	7839      	ldrb	r1, [r7, #0]
c0de09ea:	1c7f      	adds	r7, r7, #1
c0de09ec:	2200      	movs	r2, #0
c0de09ee:	292d      	cmp	r1, #45	; 0x2d
c0de09f0:	d0f9      	beq.n	c0de09e6 <mcu_usb_printf+0x52>
c0de09f2:	460a      	mov	r2, r1
c0de09f4:	3a30      	subs	r2, #48	; 0x30
c0de09f6:	2a0a      	cmp	r2, #10
c0de09f8:	d316      	bcc.n	c0de0a28 <mcu_usb_printf+0x94>
c0de09fa:	2925      	cmp	r1, #37	; 0x25
c0de09fc:	d045      	beq.n	c0de0a8a <mcu_usb_printf+0xf6>
c0de09fe:	292a      	cmp	r1, #42	; 0x2a
c0de0a00:	9703      	str	r7, [sp, #12]
c0de0a02:	d020      	beq.n	c0de0a46 <mcu_usb_printf+0xb2>
c0de0a04:	292e      	cmp	r1, #46	; 0x2e
c0de0a06:	d129      	bne.n	c0de0a5c <mcu_usb_printf+0xc8>
                // special %.*H or %.*h format to print a given length of hex digits (case: H UPPER, h lower)
                //
                case '.':
                {
                  // ensure next char is '*' and next one is 's'
                  if (format[0] == '*' && (format[1] == 's' || format[1] == 'H' || format[1] == 'h')) {
c0de0a08:	7838      	ldrb	r0, [r7, #0]
c0de0a0a:	282a      	cmp	r0, #42	; 0x2a
c0de0a0c:	d17b      	bne.n	c0de0b06 <mcu_usb_printf+0x172>
c0de0a0e:	9803      	ldr	r0, [sp, #12]
c0de0a10:	7840      	ldrb	r0, [r0, #1]
c0de0a12:	2848      	cmp	r0, #72	; 0x48
c0de0a14:	d003      	beq.n	c0de0a1e <mcu_usb_printf+0x8a>
c0de0a16:	2873      	cmp	r0, #115	; 0x73
c0de0a18:	d001      	beq.n	c0de0a1e <mcu_usb_printf+0x8a>
c0de0a1a:	2868      	cmp	r0, #104	; 0x68
c0de0a1c:	d173      	bne.n	c0de0b06 <mcu_usb_printf+0x172>
c0de0a1e:	9f03      	ldr	r7, [sp, #12]
c0de0a20:	1c7f      	adds	r7, r7, #1
c0de0a22:	2201      	movs	r2, #1

                    // skip '*' char
                    format++;

                    ulStrlen = va_arg(vaArgP, unsigned long);
c0de0a24:	9808      	ldr	r0, [sp, #32]
c0de0a26:	e014      	b.n	c0de0a52 <mcu_usb_printf+0xbe>
c0de0a28:	9304      	str	r3, [sp, #16]
c0de0a2a:	2230      	movs	r2, #48	; 0x30
                    if((format[-1] == '0') && (ulCount == 0))
c0de0a2c:	460b      	mov	r3, r1
c0de0a2e:	4053      	eors	r3, r2
c0de0a30:	4626      	mov	r6, r4
c0de0a32:	4323      	orrs	r3, r4
c0de0a34:	d000      	beq.n	c0de0a38 <mcu_usb_printf+0xa4>
c0de0a36:	9a04      	ldr	r2, [sp, #16]
c0de0a38:	230a      	movs	r3, #10
                    ulCount *= 10;
c0de0a3a:	4373      	muls	r3, r6
                    ulCount += format[-1] - '0';
c0de0a3c:	185c      	adds	r4, r3, r1
c0de0a3e:	3c30      	subs	r4, #48	; 0x30
c0de0a40:	4613      	mov	r3, r2
c0de0a42:	4602      	mov	r2, r0
c0de0a44:	e7cf      	b.n	c0de09e6 <mcu_usb_printf+0x52>
                  goto error;
                }

                case '*':
                {
                  if (*format == 's' ) {
c0de0a46:	7838      	ldrb	r0, [r7, #0]
c0de0a48:	2873      	cmp	r0, #115	; 0x73
c0de0a4a:	d15c      	bne.n	c0de0b06 <mcu_usb_printf+0x172>
c0de0a4c:	2202      	movs	r2, #2

                    ulStrlen = va_arg(vaArgP, unsigned long);
c0de0a4e:	9808      	ldr	r0, [sp, #32]
c0de0a50:	9f03      	ldr	r7, [sp, #12]
c0de0a52:	1d01      	adds	r1, r0, #4
c0de0a54:	9108      	str	r1, [sp, #32]
c0de0a56:	6800      	ldr	r0, [r0, #0]
            switch(*format++)
c0de0a58:	9007      	str	r0, [sp, #28]
c0de0a5a:	e7c4      	b.n	c0de09e6 <mcu_usb_printf+0x52>
c0de0a5c:	2948      	cmp	r1, #72	; 0x48
c0de0a5e:	d016      	beq.n	c0de0a8e <mcu_usb_printf+0xfa>
c0de0a60:	2958      	cmp	r1, #88	; 0x58
c0de0a62:	d018      	beq.n	c0de0a96 <mcu_usb_printf+0x102>
c0de0a64:	2963      	cmp	r1, #99	; 0x63
c0de0a66:	d021      	beq.n	c0de0aac <mcu_usb_printf+0x118>
c0de0a68:	2964      	cmp	r1, #100	; 0x64
c0de0a6a:	d029      	beq.n	c0de0ac0 <mcu_usb_printf+0x12c>
c0de0a6c:	4f88      	ldr	r7, [pc, #544]	; (c0de0c90 <mcu_usb_printf+0x2fc>)
c0de0a6e:	447f      	add	r7, pc
c0de0a70:	2968      	cmp	r1, #104	; 0x68
c0de0a72:	d034      	beq.n	c0de0ade <mcu_usb_printf+0x14a>
c0de0a74:	2970      	cmp	r1, #112	; 0x70
c0de0a76:	d005      	beq.n	c0de0a84 <mcu_usb_printf+0xf0>
c0de0a78:	2973      	cmp	r1, #115	; 0x73
c0de0a7a:	d033      	beq.n	c0de0ae4 <mcu_usb_printf+0x150>
c0de0a7c:	2975      	cmp	r1, #117	; 0x75
c0de0a7e:	d046      	beq.n	c0de0b0e <mcu_usb_printf+0x17a>
c0de0a80:	2978      	cmp	r1, #120	; 0x78
c0de0a82:	d140      	bne.n	c0de0b06 <mcu_usb_printf+0x172>
c0de0a84:	9304      	str	r3, [sp, #16]
c0de0a86:	2000      	movs	r0, #0
c0de0a88:	e007      	b.n	c0de0a9a <mcu_usb_printf+0x106>
                case '%':
                {
                    //
                    // Simply write a single %.
                    //
                    mcu_usb_prints(format - 1, 1);
c0de0a8a:	1e78      	subs	r0, r7, #1
c0de0a8c:	e014      	b.n	c0de0ab8 <mcu_usb_printf+0x124>
c0de0a8e:	9406      	str	r4, [sp, #24]
c0de0a90:	4f80      	ldr	r7, [pc, #512]	; (c0de0c94 <mcu_usb_printf+0x300>)
c0de0a92:	447f      	add	r7, pc
c0de0a94:	e024      	b.n	c0de0ae0 <mcu_usb_printf+0x14c>
c0de0a96:	9304      	str	r3, [sp, #16]
c0de0a98:	2001      	movs	r0, #1
c0de0a9a:	9000      	str	r0, [sp, #0]
                    ulValue = va_arg(vaArgP, unsigned long);
c0de0a9c:	9808      	ldr	r0, [sp, #32]
c0de0a9e:	1d01      	adds	r1, r0, #4
c0de0aa0:	9108      	str	r1, [sp, #32]
c0de0aa2:	6800      	ldr	r0, [r0, #0]
c0de0aa4:	9005      	str	r0, [sp, #20]
c0de0aa6:	900d      	str	r0, [sp, #52]	; 0x34
c0de0aa8:	2010      	movs	r0, #16
c0de0aaa:	e03a      	b.n	c0de0b22 <mcu_usb_printf+0x18e>
                    ulValue = va_arg(vaArgP, unsigned long);
c0de0aac:	9808      	ldr	r0, [sp, #32]
c0de0aae:	1d01      	adds	r1, r0, #4
c0de0ab0:	9108      	str	r1, [sp, #32]
c0de0ab2:	6800      	ldr	r0, [r0, #0]
c0de0ab4:	900d      	str	r0, [sp, #52]	; 0x34
c0de0ab6:	a80d      	add	r0, sp, #52	; 0x34
c0de0ab8:	2101      	movs	r1, #1
c0de0aba:	f7ff ff59 	bl	c0de0970 <mcu_usb_prints>
c0de0abe:	e776      	b.n	c0de09ae <mcu_usb_printf+0x1a>
                    ulValue = va_arg(vaArgP, unsigned long);
c0de0ac0:	9808      	ldr	r0, [sp, #32]
c0de0ac2:	1d01      	adds	r1, r0, #4
c0de0ac4:	9108      	str	r1, [sp, #32]
c0de0ac6:	6800      	ldr	r0, [r0, #0]
c0de0ac8:	900d      	str	r0, [sp, #52]	; 0x34
c0de0aca:	210a      	movs	r1, #10
                    if((long)ulValue < 0)
c0de0acc:	2800      	cmp	r0, #0
c0de0ace:	9304      	str	r3, [sp, #16]
c0de0ad0:	9106      	str	r1, [sp, #24]
c0de0ad2:	d500      	bpl.n	c0de0ad6 <mcu_usb_printf+0x142>
c0de0ad4:	e0c5      	b.n	c0de0c62 <mcu_usb_printf+0x2ce>
c0de0ad6:	9005      	str	r0, [sp, #20]
c0de0ad8:	2000      	movs	r0, #0
c0de0ada:	9000      	str	r0, [sp, #0]
c0de0adc:	e022      	b.n	c0de0b24 <mcu_usb_printf+0x190>
c0de0ade:	9406      	str	r4, [sp, #24]
c0de0ae0:	9902      	ldr	r1, [sp, #8]
c0de0ae2:	e001      	b.n	c0de0ae8 <mcu_usb_printf+0x154>
c0de0ae4:	9406      	str	r4, [sp, #24]
c0de0ae6:	2100      	movs	r1, #0
                    pcStr = va_arg(vaArgP, char *);
c0de0ae8:	9a08      	ldr	r2, [sp, #32]
c0de0aea:	1d13      	adds	r3, r2, #4
c0de0aec:	9308      	str	r3, [sp, #32]
                    switch(cStrlenSet) {
c0de0aee:	b2c0      	uxtb	r0, r0
                    pcStr = va_arg(vaArgP, char *);
c0de0af0:	6814      	ldr	r4, [r2, #0]
                    switch(cStrlenSet) {
c0de0af2:	2800      	cmp	r0, #0
c0de0af4:	d074      	beq.n	c0de0be0 <mcu_usb_printf+0x24c>
c0de0af6:	2801      	cmp	r0, #1
c0de0af8:	d079      	beq.n	c0de0bee <mcu_usb_printf+0x25a>
c0de0afa:	2802      	cmp	r0, #2
c0de0afc:	d178      	bne.n	c0de0bf0 <mcu_usb_printf+0x25c>
                        if (pcStr[0] == '\0') {
c0de0afe:	7820      	ldrb	r0, [r4, #0]
c0de0b00:	2800      	cmp	r0, #0
c0de0b02:	d100      	bne.n	c0de0b06 <mcu_usb_printf+0x172>
c0de0b04:	e0b4      	b.n	c0de0c70 <mcu_usb_printf+0x2dc>
                default:
                {
                    //
                    // Indicate an error.
                    //
                    mcu_usb_prints("ERROR", 5);
c0de0b06:	4868      	ldr	r0, [pc, #416]	; (c0de0ca8 <mcu_usb_printf+0x314>)
c0de0b08:	4478      	add	r0, pc
c0de0b0a:	2105      	movs	r1, #5
c0de0b0c:	e064      	b.n	c0de0bd8 <mcu_usb_printf+0x244>
c0de0b0e:	9304      	str	r3, [sp, #16]
                    ulValue = va_arg(vaArgP, unsigned long);
c0de0b10:	9808      	ldr	r0, [sp, #32]
c0de0b12:	1d01      	adds	r1, r0, #4
c0de0b14:	9108      	str	r1, [sp, #32]
c0de0b16:	6800      	ldr	r0, [r0, #0]
c0de0b18:	9005      	str	r0, [sp, #20]
c0de0b1a:	900d      	str	r0, [sp, #52]	; 0x34
c0de0b1c:	2000      	movs	r0, #0
c0de0b1e:	9000      	str	r0, [sp, #0]
c0de0b20:	200a      	movs	r0, #10
c0de0b22:	9006      	str	r0, [sp, #24]
c0de0b24:	9f02      	ldr	r7, [sp, #8]
c0de0b26:	4639      	mov	r1, r7
c0de0b28:	485d      	ldr	r0, [pc, #372]	; (c0de0ca0 <mcu_usb_printf+0x30c>)
c0de0b2a:	4478      	add	r0, pc
                    for(ulIdx = 1;
c0de0b2c:	9007      	str	r0, [sp, #28]
c0de0b2e:	9101      	str	r1, [sp, #4]
c0de0b30:	19c8      	adds	r0, r1, r7
c0de0b32:	4038      	ands	r0, r7
c0de0b34:	1a26      	subs	r6, r4, r0
c0de0b36:	1e75      	subs	r5, r6, #1
c0de0b38:	2400      	movs	r4, #0
                        (((ulIdx * ulBase) <= ulValue) &&
c0de0b3a:	9806      	ldr	r0, [sp, #24]
c0de0b3c:	4621      	mov	r1, r4
c0de0b3e:	463a      	mov	r2, r7
c0de0b40:	4623      	mov	r3, r4
c0de0b42:	f000 f9d1 	bl	c0de0ee8 <__aeabi_lmul>
c0de0b46:	1e4a      	subs	r2, r1, #1
c0de0b48:	4191      	sbcs	r1, r2
c0de0b4a:	9a05      	ldr	r2, [sp, #20]
c0de0b4c:	4290      	cmp	r0, r2
c0de0b4e:	d805      	bhi.n	c0de0b5c <mcu_usb_printf+0x1c8>
                    for(ulIdx = 1;
c0de0b50:	2900      	cmp	r1, #0
c0de0b52:	d103      	bne.n	c0de0b5c <mcu_usb_printf+0x1c8>
c0de0b54:	1e6d      	subs	r5, r5, #1
c0de0b56:	1e76      	subs	r6, r6, #1
c0de0b58:	4607      	mov	r7, r0
c0de0b5a:	e7ed      	b.n	c0de0b38 <mcu_usb_printf+0x1a4>
                    if(ulNeg && (cFill == '0'))
c0de0b5c:	9801      	ldr	r0, [sp, #4]
c0de0b5e:	2800      	cmp	r0, #0
c0de0b60:	9802      	ldr	r0, [sp, #8]
c0de0b62:	9a04      	ldr	r2, [sp, #16]
c0de0b64:	d109      	bne.n	c0de0b7a <mcu_usb_printf+0x1e6>
c0de0b66:	b2d1      	uxtb	r1, r2
c0de0b68:	2000      	movs	r0, #0
c0de0b6a:	2930      	cmp	r1, #48	; 0x30
c0de0b6c:	4604      	mov	r4, r0
c0de0b6e:	d104      	bne.n	c0de0b7a <mcu_usb_printf+0x1e6>
c0de0b70:	a809      	add	r0, sp, #36	; 0x24
c0de0b72:	212d      	movs	r1, #45	; 0x2d
                        pcBuf[ulPos++] = '-';
c0de0b74:	7001      	strb	r1, [r0, #0]
c0de0b76:	2401      	movs	r4, #1
c0de0b78:	9802      	ldr	r0, [sp, #8]
                    if((ulCount > 1) && (ulCount < 16))
c0de0b7a:	1eb1      	subs	r1, r6, #2
c0de0b7c:	290d      	cmp	r1, #13
c0de0b7e:	d807      	bhi.n	c0de0b90 <mcu_usb_printf+0x1fc>
c0de0b80:	9e06      	ldr	r6, [sp, #24]
                        for(ulCount--; ulCount; ulCount--)
c0de0b82:	2d00      	cmp	r5, #0
c0de0b84:	d005      	beq.n	c0de0b92 <mcu_usb_printf+0x1fe>
c0de0b86:	a909      	add	r1, sp, #36	; 0x24
                            pcBuf[ulPos++] = cFill;
c0de0b88:	550a      	strb	r2, [r1, r4]
                        for(ulCount--; ulCount; ulCount--)
c0de0b8a:	1e6d      	subs	r5, r5, #1
                            pcBuf[ulPos++] = cFill;
c0de0b8c:	1c64      	adds	r4, r4, #1
c0de0b8e:	e7f8      	b.n	c0de0b82 <mcu_usb_printf+0x1ee>
c0de0b90:	9e06      	ldr	r6, [sp, #24]
                    if(ulNeg)
c0de0b92:	2800      	cmp	r0, #0
c0de0b94:	9d05      	ldr	r5, [sp, #20]
c0de0b96:	d103      	bne.n	c0de0ba0 <mcu_usb_printf+0x20c>
c0de0b98:	a809      	add	r0, sp, #36	; 0x24
c0de0b9a:	212d      	movs	r1, #45	; 0x2d
                        pcBuf[ulPos++] = '-';
c0de0b9c:	5501      	strb	r1, [r0, r4]
c0de0b9e:	1c64      	adds	r4, r4, #1
c0de0ba0:	9800      	ldr	r0, [sp, #0]
c0de0ba2:	2800      	cmp	r0, #0
c0de0ba4:	d114      	bne.n	c0de0bd0 <mcu_usb_printf+0x23c>
c0de0ba6:	483f      	ldr	r0, [pc, #252]	; (c0de0ca4 <mcu_usb_printf+0x310>)
c0de0ba8:	4478      	add	r0, pc
c0de0baa:	9007      	str	r0, [sp, #28]
c0de0bac:	e010      	b.n	c0de0bd0 <mcu_usb_printf+0x23c>
c0de0bae:	4628      	mov	r0, r5
c0de0bb0:	4639      	mov	r1, r7
c0de0bb2:	f000 f8ed 	bl	c0de0d90 <__udivsi3>
c0de0bb6:	4631      	mov	r1, r6
c0de0bb8:	f000 f970 	bl	c0de0e9c <__aeabi_uidivmod>
c0de0bbc:	9807      	ldr	r0, [sp, #28]
c0de0bbe:	5c40      	ldrb	r0, [r0, r1]
c0de0bc0:	a909      	add	r1, sp, #36	; 0x24
                          pcBuf[ulPos++] = g_pcHex[(ulValue / ulIdx) % ulBase];
c0de0bc2:	5508      	strb	r0, [r1, r4]
                    for(; ulIdx; ulIdx /= ulBase)
c0de0bc4:	4638      	mov	r0, r7
c0de0bc6:	4631      	mov	r1, r6
c0de0bc8:	f000 f8e2 	bl	c0de0d90 <__udivsi3>
c0de0bcc:	4607      	mov	r7, r0
c0de0bce:	1c64      	adds	r4, r4, #1
c0de0bd0:	2f00      	cmp	r7, #0
c0de0bd2:	d1ec      	bne.n	c0de0bae <mcu_usb_printf+0x21a>
c0de0bd4:	a809      	add	r0, sp, #36	; 0x24
                    mcu_usb_prints(pcBuf, ulPos);
c0de0bd6:	4621      	mov	r1, r4
c0de0bd8:	f7ff feca 	bl	c0de0970 <mcu_usb_prints>
c0de0bdc:	9f03      	ldr	r7, [sp, #12]
c0de0bde:	e6e6      	b.n	c0de09ae <mcu_usb_printf+0x1a>
c0de0be0:	2000      	movs	r0, #0
                        for(ulIdx = 0; pcStr[ulIdx] != '\0'; ulIdx++)
c0de0be2:	5c22      	ldrb	r2, [r4, r0]
c0de0be4:	1c40      	adds	r0, r0, #1
c0de0be6:	2a00      	cmp	r2, #0
c0de0be8:	d1fb      	bne.n	c0de0be2 <mcu_usb_printf+0x24e>
                    switch(ulBase) {
c0de0bea:	1e45      	subs	r5, r0, #1
c0de0bec:	e000      	b.n	c0de0bf0 <mcu_usb_printf+0x25c>
c0de0bee:	9d07      	ldr	r5, [sp, #28]
c0de0bf0:	2900      	cmp	r1, #0
c0de0bf2:	d01a      	beq.n	c0de0c2a <mcu_usb_printf+0x296>
c0de0bf4:	2100      	movs	r1, #0
                        for (ulCount = 0; ulCount < ulIdx; ulCount++) {
c0de0bf6:	2d00      	cmp	r5, #0
c0de0bf8:	d02b      	beq.n	c0de0c52 <mcu_usb_printf+0x2be>
                          nibble1 = (pcStr[ulCount]>>4)&0xF;
c0de0bfa:	7820      	ldrb	r0, [r4, #0]
c0de0bfc:	0902      	lsrs	r2, r0, #4
c0de0bfe:	5cba      	ldrb	r2, [r7, r2]
c0de0c00:	ab09      	add	r3, sp, #36	; 0x24
c0de0c02:	545a      	strb	r2, [r3, r1]
c0de0c04:	185a      	adds	r2, r3, r1
c0de0c06:	230f      	movs	r3, #15
                          nibble2 = pcStr[ulCount]&0xF;
c0de0c08:	4003      	ands	r3, r0
c0de0c0a:	5cf8      	ldrb	r0, [r7, r3]
c0de0c0c:	7050      	strb	r0, [r2, #1]
c0de0c0e:	1c8a      	adds	r2, r1, #2
                          if (idx + 1 >= sizeof(pcBuf)) {
c0de0c10:	1cc8      	adds	r0, r1, #3
c0de0c12:	2810      	cmp	r0, #16
c0de0c14:	d201      	bcs.n	c0de0c1a <mcu_usb_printf+0x286>
c0de0c16:	4611      	mov	r1, r2
c0de0c18:	e004      	b.n	c0de0c24 <mcu_usb_printf+0x290>
c0de0c1a:	a809      	add	r0, sp, #36	; 0x24
                            mcu_usb_prints(pcBuf, idx);
c0de0c1c:	4611      	mov	r1, r2
c0de0c1e:	f7ff fea7 	bl	c0de0970 <mcu_usb_prints>
c0de0c22:	2100      	movs	r1, #0
                        for (ulCount = 0; ulCount < ulIdx; ulCount++) {
c0de0c24:	1c64      	adds	r4, r4, #1
c0de0c26:	1e6d      	subs	r5, r5, #1
c0de0c28:	e7e5      	b.n	c0de0bf6 <mcu_usb_printf+0x262>
                        mcu_usb_prints(pcStr, ulIdx);
c0de0c2a:	4620      	mov	r0, r4
c0de0c2c:	4629      	mov	r1, r5
c0de0c2e:	f7ff fe9f 	bl	c0de0970 <mcu_usb_prints>
c0de0c32:	9f03      	ldr	r7, [sp, #12]
c0de0c34:	9806      	ldr	r0, [sp, #24]
                    if(ulCount > ulIdx)
c0de0c36:	42a8      	cmp	r0, r5
c0de0c38:	d800      	bhi.n	c0de0c3c <mcu_usb_printf+0x2a8>
c0de0c3a:	e6b8      	b.n	c0de09ae <mcu_usb_printf+0x1a>
                        while(ulCount--)
c0de0c3c:	1a2c      	subs	r4, r5, r0
c0de0c3e:	2c00      	cmp	r4, #0
c0de0c40:	d100      	bne.n	c0de0c44 <mcu_usb_printf+0x2b0>
c0de0c42:	e6b4      	b.n	c0de09ae <mcu_usb_printf+0x1a>
                            mcu_usb_prints(" ", 1);
c0de0c44:	4815      	ldr	r0, [pc, #84]	; (c0de0c9c <mcu_usb_printf+0x308>)
c0de0c46:	4478      	add	r0, pc
c0de0c48:	2101      	movs	r1, #1
c0de0c4a:	f7ff fe91 	bl	c0de0970 <mcu_usb_prints>
                        while(ulCount--)
c0de0c4e:	1c64      	adds	r4, r4, #1
c0de0c50:	e7f5      	b.n	c0de0c3e <mcu_usb_printf+0x2aa>
                        if (idx != 0) {
c0de0c52:	2900      	cmp	r1, #0
c0de0c54:	9f03      	ldr	r7, [sp, #12]
c0de0c56:	d100      	bne.n	c0de0c5a <mcu_usb_printf+0x2c6>
c0de0c58:	e6a9      	b.n	c0de09ae <mcu_usb_printf+0x1a>
c0de0c5a:	a809      	add	r0, sp, #36	; 0x24
                            mcu_usb_prints(pcBuf, idx);
c0de0c5c:	f7ff fe88 	bl	c0de0970 <mcu_usb_prints>
c0de0c60:	e6a5      	b.n	c0de09ae <mcu_usb_printf+0x1a>
                        ulValue = -(long)ulValue;
c0de0c62:	4240      	negs	r0, r0
c0de0c64:	9005      	str	r0, [sp, #20]
c0de0c66:	900d      	str	r0, [sp, #52]	; 0x34
c0de0c68:	2100      	movs	r1, #0
            ulCap = 0;
c0de0c6a:	9100      	str	r1, [sp, #0]
c0de0c6c:	9f02      	ldr	r7, [sp, #8]
c0de0c6e:	e75b      	b.n	c0de0b28 <mcu_usb_printf+0x194>
                          do {
c0de0c70:	9807      	ldr	r0, [sp, #28]
c0de0c72:	1c44      	adds	r4, r0, #1
                            mcu_usb_prints(" ", 1);
c0de0c74:	4808      	ldr	r0, [pc, #32]	; (c0de0c98 <mcu_usb_printf+0x304>)
c0de0c76:	4478      	add	r0, pc
c0de0c78:	2101      	movs	r1, #1
c0de0c7a:	f7ff fe79 	bl	c0de0970 <mcu_usb_prints>
                          } while(ulStrlen-- > 0);
c0de0c7e:	1e64      	subs	r4, r4, #1
c0de0c80:	d1f8      	bne.n	c0de0c74 <mcu_usb_printf+0x2e0>
c0de0c82:	e7d6      	b.n	c0de0c32 <mcu_usb_printf+0x29e>

    //
    // End the varargs processing.
    //
    va_end(vaArgP);
}
c0de0c84:	b00e      	add	sp, #56	; 0x38
c0de0c86:	bcf0      	pop	{r4, r5, r6, r7}
c0de0c88:	bc01      	pop	{r0}
c0de0c8a:	b003      	add	sp, #12
c0de0c8c:	4700      	bx	r0
c0de0c8e:	46c0      	nop			; (mov r8, r8)
c0de0c90:	00000dea 	.word	0x00000dea
c0de0c94:	00000dd6 	.word	0x00000dd6
c0de0c98:	00000997 	.word	0x00000997
c0de0c9c:	000009c7 	.word	0x000009c7
c0de0ca0:	00000d3e 	.word	0x00000d3e
c0de0ca4:	00000cb0 	.word	0x00000cb0
c0de0ca8:	00000bc1 	.word	0x00000bc1

c0de0cac <pic_internal>:
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"
__attribute__((naked,no_instrument_function)) void *pic_internal(void *link_address)
{
  // compute the delta offset between LinkMemAddr & ExecMemAddr
  __asm volatile ("mov r2, pc\n");
c0de0cac:	467a      	mov	r2, pc
  __asm volatile ("ldr r1, =pic_internal\n");
c0de0cae:	4902      	ldr	r1, [pc, #8]	; (c0de0cb8 <pic_internal+0xc>)
  __asm volatile ("adds r1, r1, #3\n");
c0de0cb0:	1cc9      	adds	r1, r1, #3
  __asm volatile ("subs r1, r1, r2\n");
c0de0cb2:	1a89      	subs	r1, r1, r2

  // adjust value of the given parameter
  __asm volatile ("subs r0, r0, r1\n");
c0de0cb4:	1a40      	subs	r0, r0, r1
  __asm volatile ("bx lr\n");
c0de0cb6:	4770      	bx	lr
c0de0cb8:	c0de0cad 	.word	0xc0de0cad

c0de0cbc <pic>:
#elif defined(ST33) || defined(ST33K1M5)

extern void _bss;
extern void _estack;

void *pic(void *link_address) {
c0de0cbc:	b580      	push	{r7, lr}
  void *n, *en;

  // check if in the LINKED TEXT zone
  __asm volatile("ldr %0, =_nvram":"=r"(n));
c0de0cbe:	4a09      	ldr	r2, [pc, #36]	; (c0de0ce4 <pic+0x28>)
  __asm volatile("ldr %0, =_envram":"=r"(en));
c0de0cc0:	4909      	ldr	r1, [pc, #36]	; (c0de0ce8 <pic+0x2c>)
  if (link_address >= n && link_address <= en) {
c0de0cc2:	4282      	cmp	r2, r0
c0de0cc4:	d803      	bhi.n	c0de0cce <pic+0x12>
c0de0cc6:	4281      	cmp	r1, r0
c0de0cc8:	d301      	bcc.n	c0de0cce <pic+0x12>
    link_address = pic_internal(link_address);
c0de0cca:	f7ff ffef 	bl	c0de0cac <pic_internal>
  }

  // check if in the LINKED RAM zone
  __asm volatile("ldr %0, =_bss":"=r"(n));
c0de0cce:	4907      	ldr	r1, [pc, #28]	; (c0de0cec <pic+0x30>)
  __asm volatile("ldr %0, =_estack":"=r"(en));
c0de0cd0:	4a07      	ldr	r2, [pc, #28]	; (c0de0cf0 <pic+0x34>)
  if (link_address >= n && link_address <= en) {
c0de0cd2:	4288      	cmp	r0, r1
c0de0cd4:	d304      	bcc.n	c0de0ce0 <pic+0x24>
c0de0cd6:	4290      	cmp	r0, r2
c0de0cd8:	d802      	bhi.n	c0de0ce0 <pic+0x24>
    __asm volatile("mov %0, r9":"=r"(en));
    // deref into the RAM therefore add the RAM offset from R9
    link_address = (char *)link_address - (char *)n + (char *)en;
c0de0cda:	1a40      	subs	r0, r0, r1
    __asm volatile("mov %0, r9":"=r"(en));
c0de0cdc:	4649      	mov	r1, r9
    link_address = (char *)link_address - (char *)n + (char *)en;
c0de0cde:	1808      	adds	r0, r1, r0
  }

  return link_address;
c0de0ce0:	bd80      	pop	{r7, pc}
c0de0ce2:	46c0      	nop			; (mov r8, r8)
c0de0ce4:	c0de0000 	.word	0xc0de0000
c0de0ce8:	c0de1900 	.word	0xc0de1900
c0de0cec:	da7a0000 	.word	0xda7a0000
c0de0cf0:	da7a7800 	.word	0xda7a7800

c0de0cf4 <SVC_Call>:
.thumb
.thumb_func
.global SVC_Call

SVC_Call:
    svc 1
c0de0cf4:	df01      	svc	1
    cmp r1, #0
c0de0cf6:	2900      	cmp	r1, #0
    bne exception
c0de0cf8:	d100      	bne.n	c0de0cfc <exception>
    bx lr
c0de0cfa:	4770      	bx	lr

c0de0cfc <exception>:
exception:
    // THROW(ex);
    mov r0, r1
c0de0cfc:	4608      	mov	r0, r1
    bl os_longjmp
c0de0cfe:	f7ff fe29 	bl	c0de0954 <os_longjmp>

c0de0d02 <get_api_level>:
#include <string.h>

unsigned int SVC_Call(unsigned int syscall_id, void *parameters);
unsigned int SVC_cx_call(unsigned int syscall_id, unsigned int * parameters);

unsigned int get_api_level(void) {
c0de0d02:	b5e0      	push	{r5, r6, r7, lr}
c0de0d04:	2000      	movs	r0, #0
  unsigned int parameters[2];
  parameters[0] = 0;
  parameters[1] = 0;
c0de0d06:	9001      	str	r0, [sp, #4]
  parameters[0] = 0;
c0de0d08:	9000      	str	r0, [sp, #0]
c0de0d0a:	2001      	movs	r0, #1
c0de0d0c:	4669      	mov	r1, sp
  return SVC_Call(SYSCALL_get_api_level_ID, parameters);
c0de0d0e:	f7ff fff1 	bl	c0de0cf4 <SVC_Call>
c0de0d12:	bd8c      	pop	{r2, r3, r7, pc}

c0de0d14 <os_lib_call>:
  SVC_Call(SYSCALL_os_ux_result_ID, parameters);
  return;
}
#endif // !defined(APP_UX)

void os_lib_call ( unsigned int * call_parameters ) {
c0de0d14:	b5e0      	push	{r5, r6, r7, lr}
c0de0d16:	2100      	movs	r1, #0
  unsigned int parameters[2];
  parameters[0] = (unsigned int)call_parameters;
  parameters[1] = 0;
c0de0d18:	9101      	str	r1, [sp, #4]
  parameters[0] = (unsigned int)call_parameters;
c0de0d1a:	9000      	str	r0, [sp, #0]
c0de0d1c:	4802      	ldr	r0, [pc, #8]	; (c0de0d28 <os_lib_call+0x14>)
c0de0d1e:	4669      	mov	r1, sp
  SVC_Call(SYSCALL_os_lib_call_ID, parameters);
c0de0d20:	f7ff ffe8 	bl	c0de0cf4 <SVC_Call>
  return;
}
c0de0d24:	bd8c      	pop	{r2, r3, r7, pc}
c0de0d26:	46c0      	nop			; (mov r8, r8)
c0de0d28:	01000067 	.word	0x01000067

c0de0d2c <os_lib_end>:

void __attribute__((noreturn)) os_lib_end ( void ) {
c0de0d2c:	b082      	sub	sp, #8
c0de0d2e:	2000      	movs	r0, #0
  unsigned int parameters[2];
  parameters[1] = 0;
c0de0d30:	9001      	str	r0, [sp, #4]
c0de0d32:	2068      	movs	r0, #104	; 0x68
c0de0d34:	4669      	mov	r1, sp
  SVC_Call(SYSCALL_os_lib_end_ID, parameters);
c0de0d36:	f7ff ffdd 	bl	c0de0cf4 <SVC_Call>

  // The os_lib_end syscall should never return.
  // Just in case, crash the device thanks to an undefined instruction.
  // To avoid the __builtin_unreachable undefined behaviour
  asm volatile ("udf #255");
c0de0d3a:	deff      	udf	#255	; 0xff

c0de0d3c <os_sched_exit>:
  parameters[1] = 0;
  SVC_Call(SYSCALL_os_sched_exec_ID, parameters);
  return;
}

void __attribute__((noreturn)) os_sched_exit ( bolos_task_status_t exit_code ) {
c0de0d3c:	b082      	sub	sp, #8
c0de0d3e:	2100      	movs	r1, #0
  unsigned int parameters[2];
  parameters[0] = (unsigned int)exit_code;
  parameters[1] = 0;
c0de0d40:	9101      	str	r1, [sp, #4]
  parameters[0] = (unsigned int)exit_code;
c0de0d42:	9000      	str	r0, [sp, #0]
c0de0d44:	4802      	ldr	r0, [pc, #8]	; (c0de0d50 <os_sched_exit+0x14>)
c0de0d46:	4669      	mov	r1, sp
  SVC_Call(SYSCALL_os_sched_exit_ID, parameters);
c0de0d48:	f7ff ffd4 	bl	c0de0cf4 <SVC_Call>

  // The os_sched_exit syscall should never return.
  // Just in case, crash the device thanks to an undefined instruction.
  // To avoid the __builtin_unreachable undefined behaviour
  asm volatile ("udf #255");
c0de0d4c:	deff      	udf	#255	; 0xff
c0de0d4e:	46c0      	nop			; (mov r8, r8)
c0de0d50:	0100009a 	.word	0x0100009a

c0de0d54 <io_seph_send>:
  parameters[1] = 0;
  SVC_Call(SYSCALL_os_sched_kill_ID, parameters);
  return;
}

void io_seph_send ( const unsigned char * buffer, unsigned short length ) {
c0de0d54:	b5e0      	push	{r5, r6, r7, lr}
  unsigned int parameters[2];
  parameters[0] = (unsigned int)buffer;
  parameters[1] = (unsigned int)length;
c0de0d56:	9101      	str	r1, [sp, #4]
  parameters[0] = (unsigned int)buffer;
c0de0d58:	9000      	str	r0, [sp, #0]
c0de0d5a:	4802      	ldr	r0, [pc, #8]	; (c0de0d64 <io_seph_send+0x10>)
c0de0d5c:	4669      	mov	r1, sp
  SVC_Call(SYSCALL_io_seph_send_ID, parameters);
c0de0d5e:	f7ff ffc9 	bl	c0de0cf4 <SVC_Call>
  return;
}
c0de0d62:	bd8c      	pop	{r2, r3, r7, pc}
c0de0d64:	02000083 	.word	0x02000083

c0de0d68 <try_context_get>:
  parameters[1] = 0;
  SVC_Call(SYSCALL_nvm_erase_page_ID, parameters);
  return;
}

try_context_t * try_context_get ( void ) {
c0de0d68:	b5e0      	push	{r5, r6, r7, lr}
c0de0d6a:	2000      	movs	r0, #0
  unsigned int parameters[2];
  parameters[1] = 0;
c0de0d6c:	9001      	str	r0, [sp, #4]
c0de0d6e:	2087      	movs	r0, #135	; 0x87
c0de0d70:	4669      	mov	r1, sp
  return (try_context_t *) SVC_Call(SYSCALL_try_context_get_ID, parameters);
c0de0d72:	f7ff ffbf 	bl	c0de0cf4 <SVC_Call>
c0de0d76:	bd8c      	pop	{r2, r3, r7, pc}

c0de0d78 <try_context_set>:
}

try_context_t * try_context_set ( try_context_t *context ) {
c0de0d78:	b5e0      	push	{r5, r6, r7, lr}
c0de0d7a:	2100      	movs	r1, #0
  unsigned int parameters[2];
  parameters[0] = (unsigned int)context;
  parameters[1] = 0;
c0de0d7c:	9101      	str	r1, [sp, #4]
  parameters[0] = (unsigned int)context;
c0de0d7e:	9000      	str	r0, [sp, #0]
c0de0d80:	4802      	ldr	r0, [pc, #8]	; (c0de0d8c <try_context_set+0x14>)
c0de0d82:	4669      	mov	r1, sp
  return (try_context_t *) SVC_Call(SYSCALL_try_context_set_ID, parameters);
c0de0d84:	f7ff ffb6 	bl	c0de0cf4 <SVC_Call>
c0de0d88:	bd8c      	pop	{r2, r3, r7, pc}
c0de0d8a:	46c0      	nop			; (mov r8, r8)
c0de0d8c:	0100010b 	.word	0x0100010b

c0de0d90 <__udivsi3>:
c0de0d90:	2200      	movs	r2, #0
c0de0d92:	0843      	lsrs	r3, r0, #1
c0de0d94:	428b      	cmp	r3, r1
c0de0d96:	d374      	bcc.n	c0de0e82 <__udivsi3+0xf2>
c0de0d98:	0903      	lsrs	r3, r0, #4
c0de0d9a:	428b      	cmp	r3, r1
c0de0d9c:	d35f      	bcc.n	c0de0e5e <__udivsi3+0xce>
c0de0d9e:	0a03      	lsrs	r3, r0, #8
c0de0da0:	428b      	cmp	r3, r1
c0de0da2:	d344      	bcc.n	c0de0e2e <__udivsi3+0x9e>
c0de0da4:	0b03      	lsrs	r3, r0, #12
c0de0da6:	428b      	cmp	r3, r1
c0de0da8:	d328      	bcc.n	c0de0dfc <__udivsi3+0x6c>
c0de0daa:	0c03      	lsrs	r3, r0, #16
c0de0dac:	428b      	cmp	r3, r1
c0de0dae:	d30d      	bcc.n	c0de0dcc <__udivsi3+0x3c>
c0de0db0:	22ff      	movs	r2, #255	; 0xff
c0de0db2:	0209      	lsls	r1, r1, #8
c0de0db4:	ba12      	rev	r2, r2
c0de0db6:	0c03      	lsrs	r3, r0, #16
c0de0db8:	428b      	cmp	r3, r1
c0de0dba:	d302      	bcc.n	c0de0dc2 <__udivsi3+0x32>
c0de0dbc:	1212      	asrs	r2, r2, #8
c0de0dbe:	0209      	lsls	r1, r1, #8
c0de0dc0:	d065      	beq.n	c0de0e8e <__udivsi3+0xfe>
c0de0dc2:	0b03      	lsrs	r3, r0, #12
c0de0dc4:	428b      	cmp	r3, r1
c0de0dc6:	d319      	bcc.n	c0de0dfc <__udivsi3+0x6c>
c0de0dc8:	e000      	b.n	c0de0dcc <__udivsi3+0x3c>
c0de0dca:	0a09      	lsrs	r1, r1, #8
c0de0dcc:	0bc3      	lsrs	r3, r0, #15
c0de0dce:	428b      	cmp	r3, r1
c0de0dd0:	d301      	bcc.n	c0de0dd6 <__udivsi3+0x46>
c0de0dd2:	03cb      	lsls	r3, r1, #15
c0de0dd4:	1ac0      	subs	r0, r0, r3
c0de0dd6:	4152      	adcs	r2, r2
c0de0dd8:	0b83      	lsrs	r3, r0, #14
c0de0dda:	428b      	cmp	r3, r1
c0de0ddc:	d301      	bcc.n	c0de0de2 <__udivsi3+0x52>
c0de0dde:	038b      	lsls	r3, r1, #14
c0de0de0:	1ac0      	subs	r0, r0, r3
c0de0de2:	4152      	adcs	r2, r2
c0de0de4:	0b43      	lsrs	r3, r0, #13
c0de0de6:	428b      	cmp	r3, r1
c0de0de8:	d301      	bcc.n	c0de0dee <__udivsi3+0x5e>
c0de0dea:	034b      	lsls	r3, r1, #13
c0de0dec:	1ac0      	subs	r0, r0, r3
c0de0dee:	4152      	adcs	r2, r2
c0de0df0:	0b03      	lsrs	r3, r0, #12
c0de0df2:	428b      	cmp	r3, r1
c0de0df4:	d301      	bcc.n	c0de0dfa <__udivsi3+0x6a>
c0de0df6:	030b      	lsls	r3, r1, #12
c0de0df8:	1ac0      	subs	r0, r0, r3
c0de0dfa:	4152      	adcs	r2, r2
c0de0dfc:	0ac3      	lsrs	r3, r0, #11
c0de0dfe:	428b      	cmp	r3, r1
c0de0e00:	d301      	bcc.n	c0de0e06 <__udivsi3+0x76>
c0de0e02:	02cb      	lsls	r3, r1, #11
c0de0e04:	1ac0      	subs	r0, r0, r3
c0de0e06:	4152      	adcs	r2, r2
c0de0e08:	0a83      	lsrs	r3, r0, #10
c0de0e0a:	428b      	cmp	r3, r1
c0de0e0c:	d301      	bcc.n	c0de0e12 <__udivsi3+0x82>
c0de0e0e:	028b      	lsls	r3, r1, #10
c0de0e10:	1ac0      	subs	r0, r0, r3
c0de0e12:	4152      	adcs	r2, r2
c0de0e14:	0a43      	lsrs	r3, r0, #9
c0de0e16:	428b      	cmp	r3, r1
c0de0e18:	d301      	bcc.n	c0de0e1e <__udivsi3+0x8e>
c0de0e1a:	024b      	lsls	r3, r1, #9
c0de0e1c:	1ac0      	subs	r0, r0, r3
c0de0e1e:	4152      	adcs	r2, r2
c0de0e20:	0a03      	lsrs	r3, r0, #8
c0de0e22:	428b      	cmp	r3, r1
c0de0e24:	d301      	bcc.n	c0de0e2a <__udivsi3+0x9a>
c0de0e26:	020b      	lsls	r3, r1, #8
c0de0e28:	1ac0      	subs	r0, r0, r3
c0de0e2a:	4152      	adcs	r2, r2
c0de0e2c:	d2cd      	bcs.n	c0de0dca <__udivsi3+0x3a>
c0de0e2e:	09c3      	lsrs	r3, r0, #7
c0de0e30:	428b      	cmp	r3, r1
c0de0e32:	d301      	bcc.n	c0de0e38 <__udivsi3+0xa8>
c0de0e34:	01cb      	lsls	r3, r1, #7
c0de0e36:	1ac0      	subs	r0, r0, r3
c0de0e38:	4152      	adcs	r2, r2
c0de0e3a:	0983      	lsrs	r3, r0, #6
c0de0e3c:	428b      	cmp	r3, r1
c0de0e3e:	d301      	bcc.n	c0de0e44 <__udivsi3+0xb4>
c0de0e40:	018b      	lsls	r3, r1, #6
c0de0e42:	1ac0      	subs	r0, r0, r3
c0de0e44:	4152      	adcs	r2, r2
c0de0e46:	0943      	lsrs	r3, r0, #5
c0de0e48:	428b      	cmp	r3, r1
c0de0e4a:	d301      	bcc.n	c0de0e50 <__udivsi3+0xc0>
c0de0e4c:	014b      	lsls	r3, r1, #5
c0de0e4e:	1ac0      	subs	r0, r0, r3
c0de0e50:	4152      	adcs	r2, r2
c0de0e52:	0903      	lsrs	r3, r0, #4
c0de0e54:	428b      	cmp	r3, r1
c0de0e56:	d301      	bcc.n	c0de0e5c <__udivsi3+0xcc>
c0de0e58:	010b      	lsls	r3, r1, #4
c0de0e5a:	1ac0      	subs	r0, r0, r3
c0de0e5c:	4152      	adcs	r2, r2
c0de0e5e:	08c3      	lsrs	r3, r0, #3
c0de0e60:	428b      	cmp	r3, r1
c0de0e62:	d301      	bcc.n	c0de0e68 <__udivsi3+0xd8>
c0de0e64:	00cb      	lsls	r3, r1, #3
c0de0e66:	1ac0      	subs	r0, r0, r3
c0de0e68:	4152      	adcs	r2, r2
c0de0e6a:	0883      	lsrs	r3, r0, #2
c0de0e6c:	428b      	cmp	r3, r1
c0de0e6e:	d301      	bcc.n	c0de0e74 <__udivsi3+0xe4>
c0de0e70:	008b      	lsls	r3, r1, #2
c0de0e72:	1ac0      	subs	r0, r0, r3
c0de0e74:	4152      	adcs	r2, r2
c0de0e76:	0843      	lsrs	r3, r0, #1
c0de0e78:	428b      	cmp	r3, r1
c0de0e7a:	d301      	bcc.n	c0de0e80 <__udivsi3+0xf0>
c0de0e7c:	004b      	lsls	r3, r1, #1
c0de0e7e:	1ac0      	subs	r0, r0, r3
c0de0e80:	4152      	adcs	r2, r2
c0de0e82:	1a41      	subs	r1, r0, r1
c0de0e84:	d200      	bcs.n	c0de0e88 <__udivsi3+0xf8>
c0de0e86:	4601      	mov	r1, r0
c0de0e88:	4152      	adcs	r2, r2
c0de0e8a:	4610      	mov	r0, r2
c0de0e8c:	4770      	bx	lr
c0de0e8e:	e7ff      	b.n	c0de0e90 <__udivsi3+0x100>
c0de0e90:	b501      	push	{r0, lr}
c0de0e92:	2000      	movs	r0, #0
c0de0e94:	f000 f806 	bl	c0de0ea4 <__aeabi_idiv0>
c0de0e98:	bd02      	pop	{r1, pc}
c0de0e9a:	46c0      	nop			; (mov r8, r8)

c0de0e9c <__aeabi_uidivmod>:
c0de0e9c:	2900      	cmp	r1, #0
c0de0e9e:	d0f7      	beq.n	c0de0e90 <__udivsi3+0x100>
c0de0ea0:	e776      	b.n	c0de0d90 <__udivsi3>
c0de0ea2:	4770      	bx	lr

c0de0ea4 <__aeabi_idiv0>:
c0de0ea4:	4770      	bx	lr
c0de0ea6:	46c0      	nop			; (mov r8, r8)

c0de0ea8 <__aeabi_uldivmod>:
c0de0ea8:	2b00      	cmp	r3, #0
c0de0eaa:	d111      	bne.n	c0de0ed0 <__aeabi_uldivmod+0x28>
c0de0eac:	2a00      	cmp	r2, #0
c0de0eae:	d10f      	bne.n	c0de0ed0 <__aeabi_uldivmod+0x28>
c0de0eb0:	2900      	cmp	r1, #0
c0de0eb2:	d100      	bne.n	c0de0eb6 <__aeabi_uldivmod+0xe>
c0de0eb4:	2800      	cmp	r0, #0
c0de0eb6:	d002      	beq.n	c0de0ebe <__aeabi_uldivmod+0x16>
c0de0eb8:	2100      	movs	r1, #0
c0de0eba:	43c9      	mvns	r1, r1
c0de0ebc:	1c08      	adds	r0, r1, #0
c0de0ebe:	b407      	push	{r0, r1, r2}
c0de0ec0:	4802      	ldr	r0, [pc, #8]	; (c0de0ecc <__aeabi_uldivmod+0x24>)
c0de0ec2:	a102      	add	r1, pc, #8	; (adr r1, c0de0ecc <__aeabi_uldivmod+0x24>)
c0de0ec4:	1840      	adds	r0, r0, r1
c0de0ec6:	9002      	str	r0, [sp, #8]
c0de0ec8:	bd03      	pop	{r0, r1, pc}
c0de0eca:	46c0      	nop			; (mov r8, r8)
c0de0ecc:	ffffffd9 	.word	0xffffffd9
c0de0ed0:	b403      	push	{r0, r1}
c0de0ed2:	4668      	mov	r0, sp
c0de0ed4:	b501      	push	{r0, lr}
c0de0ed6:	9802      	ldr	r0, [sp, #8]
c0de0ed8:	f000 f830 	bl	c0de0f3c <__udivmoddi4>
c0de0edc:	9b01      	ldr	r3, [sp, #4]
c0de0ede:	469e      	mov	lr, r3
c0de0ee0:	b002      	add	sp, #8
c0de0ee2:	bc0c      	pop	{r2, r3}
c0de0ee4:	4770      	bx	lr
c0de0ee6:	46c0      	nop			; (mov r8, r8)

c0de0ee8 <__aeabi_lmul>:
c0de0ee8:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de0eea:	46ce      	mov	lr, r9
c0de0eec:	4647      	mov	r7, r8
c0de0eee:	0415      	lsls	r5, r2, #16
c0de0ef0:	0c2d      	lsrs	r5, r5, #16
c0de0ef2:	002e      	movs	r6, r5
c0de0ef4:	b580      	push	{r7, lr}
c0de0ef6:	0407      	lsls	r7, r0, #16
c0de0ef8:	0c14      	lsrs	r4, r2, #16
c0de0efa:	0c3f      	lsrs	r7, r7, #16
c0de0efc:	4699      	mov	r9, r3
c0de0efe:	0c03      	lsrs	r3, r0, #16
c0de0f00:	437e      	muls	r6, r7
c0de0f02:	435d      	muls	r5, r3
c0de0f04:	4367      	muls	r7, r4
c0de0f06:	4363      	muls	r3, r4
c0de0f08:	197f      	adds	r7, r7, r5
c0de0f0a:	0c34      	lsrs	r4, r6, #16
c0de0f0c:	19e4      	adds	r4, r4, r7
c0de0f0e:	469c      	mov	ip, r3
c0de0f10:	42a5      	cmp	r5, r4
c0de0f12:	d903      	bls.n	c0de0f1c <__aeabi_lmul+0x34>
c0de0f14:	2380      	movs	r3, #128	; 0x80
c0de0f16:	025b      	lsls	r3, r3, #9
c0de0f18:	4698      	mov	r8, r3
c0de0f1a:	44c4      	add	ip, r8
c0de0f1c:	464b      	mov	r3, r9
c0de0f1e:	4343      	muls	r3, r0
c0de0f20:	4351      	muls	r1, r2
c0de0f22:	0c25      	lsrs	r5, r4, #16
c0de0f24:	0436      	lsls	r6, r6, #16
c0de0f26:	4465      	add	r5, ip
c0de0f28:	0c36      	lsrs	r6, r6, #16
c0de0f2a:	0424      	lsls	r4, r4, #16
c0de0f2c:	19a4      	adds	r4, r4, r6
c0de0f2e:	195b      	adds	r3, r3, r5
c0de0f30:	1859      	adds	r1, r3, r1
c0de0f32:	0020      	movs	r0, r4
c0de0f34:	bc0c      	pop	{r2, r3}
c0de0f36:	4690      	mov	r8, r2
c0de0f38:	4699      	mov	r9, r3
c0de0f3a:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0de0f3c <__udivmoddi4>:
c0de0f3c:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de0f3e:	4657      	mov	r7, sl
c0de0f40:	464e      	mov	r6, r9
c0de0f42:	4645      	mov	r5, r8
c0de0f44:	46de      	mov	lr, fp
c0de0f46:	b5e0      	push	{r5, r6, r7, lr}
c0de0f48:	0004      	movs	r4, r0
c0de0f4a:	b083      	sub	sp, #12
c0de0f4c:	000d      	movs	r5, r1
c0de0f4e:	4692      	mov	sl, r2
c0de0f50:	4699      	mov	r9, r3
c0de0f52:	428b      	cmp	r3, r1
c0de0f54:	d830      	bhi.n	c0de0fb8 <__udivmoddi4+0x7c>
c0de0f56:	d02d      	beq.n	c0de0fb4 <__udivmoddi4+0x78>
c0de0f58:	4649      	mov	r1, r9
c0de0f5a:	4650      	mov	r0, sl
c0de0f5c:	f000 f8c0 	bl	c0de10e0 <__clzdi2>
c0de0f60:	0029      	movs	r1, r5
c0de0f62:	0006      	movs	r6, r0
c0de0f64:	0020      	movs	r0, r4
c0de0f66:	f000 f8bb 	bl	c0de10e0 <__clzdi2>
c0de0f6a:	1a33      	subs	r3, r6, r0
c0de0f6c:	4698      	mov	r8, r3
c0de0f6e:	3b20      	subs	r3, #32
c0de0f70:	469b      	mov	fp, r3
c0de0f72:	d433      	bmi.n	c0de0fdc <__udivmoddi4+0xa0>
c0de0f74:	465a      	mov	r2, fp
c0de0f76:	4653      	mov	r3, sl
c0de0f78:	4093      	lsls	r3, r2
c0de0f7a:	4642      	mov	r2, r8
c0de0f7c:	001f      	movs	r7, r3
c0de0f7e:	4653      	mov	r3, sl
c0de0f80:	4093      	lsls	r3, r2
c0de0f82:	001e      	movs	r6, r3
c0de0f84:	42af      	cmp	r7, r5
c0de0f86:	d83a      	bhi.n	c0de0ffe <__udivmoddi4+0xc2>
c0de0f88:	42af      	cmp	r7, r5
c0de0f8a:	d100      	bne.n	c0de0f8e <__udivmoddi4+0x52>
c0de0f8c:	e07b      	b.n	c0de1086 <__udivmoddi4+0x14a>
c0de0f8e:	465b      	mov	r3, fp
c0de0f90:	1ba4      	subs	r4, r4, r6
c0de0f92:	41bd      	sbcs	r5, r7
c0de0f94:	2b00      	cmp	r3, #0
c0de0f96:	da00      	bge.n	c0de0f9a <__udivmoddi4+0x5e>
c0de0f98:	e078      	b.n	c0de108c <__udivmoddi4+0x150>
c0de0f9a:	2200      	movs	r2, #0
c0de0f9c:	2300      	movs	r3, #0
c0de0f9e:	9200      	str	r2, [sp, #0]
c0de0fa0:	9301      	str	r3, [sp, #4]
c0de0fa2:	2301      	movs	r3, #1
c0de0fa4:	465a      	mov	r2, fp
c0de0fa6:	4093      	lsls	r3, r2
c0de0fa8:	9301      	str	r3, [sp, #4]
c0de0faa:	2301      	movs	r3, #1
c0de0fac:	4642      	mov	r2, r8
c0de0fae:	4093      	lsls	r3, r2
c0de0fb0:	9300      	str	r3, [sp, #0]
c0de0fb2:	e028      	b.n	c0de1006 <__udivmoddi4+0xca>
c0de0fb4:	4282      	cmp	r2, r0
c0de0fb6:	d9cf      	bls.n	c0de0f58 <__udivmoddi4+0x1c>
c0de0fb8:	2200      	movs	r2, #0
c0de0fba:	2300      	movs	r3, #0
c0de0fbc:	9200      	str	r2, [sp, #0]
c0de0fbe:	9301      	str	r3, [sp, #4]
c0de0fc0:	9b0c      	ldr	r3, [sp, #48]	; 0x30
c0de0fc2:	2b00      	cmp	r3, #0
c0de0fc4:	d001      	beq.n	c0de0fca <__udivmoddi4+0x8e>
c0de0fc6:	601c      	str	r4, [r3, #0]
c0de0fc8:	605d      	str	r5, [r3, #4]
c0de0fca:	9800      	ldr	r0, [sp, #0]
c0de0fcc:	9901      	ldr	r1, [sp, #4]
c0de0fce:	b003      	add	sp, #12
c0de0fd0:	bc3c      	pop	{r2, r3, r4, r5}
c0de0fd2:	4690      	mov	r8, r2
c0de0fd4:	4699      	mov	r9, r3
c0de0fd6:	46a2      	mov	sl, r4
c0de0fd8:	46ab      	mov	fp, r5
c0de0fda:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0de0fdc:	4642      	mov	r2, r8
c0de0fde:	2320      	movs	r3, #32
c0de0fe0:	1a9b      	subs	r3, r3, r2
c0de0fe2:	4652      	mov	r2, sl
c0de0fe4:	40da      	lsrs	r2, r3
c0de0fe6:	4641      	mov	r1, r8
c0de0fe8:	0013      	movs	r3, r2
c0de0fea:	464a      	mov	r2, r9
c0de0fec:	408a      	lsls	r2, r1
c0de0fee:	0017      	movs	r7, r2
c0de0ff0:	4642      	mov	r2, r8
c0de0ff2:	431f      	orrs	r7, r3
c0de0ff4:	4653      	mov	r3, sl
c0de0ff6:	4093      	lsls	r3, r2
c0de0ff8:	001e      	movs	r6, r3
c0de0ffa:	42af      	cmp	r7, r5
c0de0ffc:	d9c4      	bls.n	c0de0f88 <__udivmoddi4+0x4c>
c0de0ffe:	2200      	movs	r2, #0
c0de1000:	2300      	movs	r3, #0
c0de1002:	9200      	str	r2, [sp, #0]
c0de1004:	9301      	str	r3, [sp, #4]
c0de1006:	4643      	mov	r3, r8
c0de1008:	2b00      	cmp	r3, #0
c0de100a:	d0d9      	beq.n	c0de0fc0 <__udivmoddi4+0x84>
c0de100c:	07fb      	lsls	r3, r7, #31
c0de100e:	469c      	mov	ip, r3
c0de1010:	4661      	mov	r1, ip
c0de1012:	0872      	lsrs	r2, r6, #1
c0de1014:	430a      	orrs	r2, r1
c0de1016:	087b      	lsrs	r3, r7, #1
c0de1018:	4646      	mov	r6, r8
c0de101a:	e00e      	b.n	c0de103a <__udivmoddi4+0xfe>
c0de101c:	42ab      	cmp	r3, r5
c0de101e:	d101      	bne.n	c0de1024 <__udivmoddi4+0xe8>
c0de1020:	42a2      	cmp	r2, r4
c0de1022:	d80c      	bhi.n	c0de103e <__udivmoddi4+0x102>
c0de1024:	1aa4      	subs	r4, r4, r2
c0de1026:	419d      	sbcs	r5, r3
c0de1028:	2001      	movs	r0, #1
c0de102a:	1924      	adds	r4, r4, r4
c0de102c:	416d      	adcs	r5, r5
c0de102e:	2100      	movs	r1, #0
c0de1030:	3e01      	subs	r6, #1
c0de1032:	1824      	adds	r4, r4, r0
c0de1034:	414d      	adcs	r5, r1
c0de1036:	2e00      	cmp	r6, #0
c0de1038:	d006      	beq.n	c0de1048 <__udivmoddi4+0x10c>
c0de103a:	42ab      	cmp	r3, r5
c0de103c:	d9ee      	bls.n	c0de101c <__udivmoddi4+0xe0>
c0de103e:	3e01      	subs	r6, #1
c0de1040:	1924      	adds	r4, r4, r4
c0de1042:	416d      	adcs	r5, r5
c0de1044:	2e00      	cmp	r6, #0
c0de1046:	d1f8      	bne.n	c0de103a <__udivmoddi4+0xfe>
c0de1048:	9800      	ldr	r0, [sp, #0]
c0de104a:	9901      	ldr	r1, [sp, #4]
c0de104c:	465b      	mov	r3, fp
c0de104e:	1900      	adds	r0, r0, r4
c0de1050:	4169      	adcs	r1, r5
c0de1052:	2b00      	cmp	r3, #0
c0de1054:	db25      	blt.n	c0de10a2 <__udivmoddi4+0x166>
c0de1056:	002b      	movs	r3, r5
c0de1058:	465a      	mov	r2, fp
c0de105a:	4644      	mov	r4, r8
c0de105c:	40d3      	lsrs	r3, r2
c0de105e:	002a      	movs	r2, r5
c0de1060:	40e2      	lsrs	r2, r4
c0de1062:	001c      	movs	r4, r3
c0de1064:	465b      	mov	r3, fp
c0de1066:	0015      	movs	r5, r2
c0de1068:	2b00      	cmp	r3, #0
c0de106a:	db2b      	blt.n	c0de10c4 <__udivmoddi4+0x188>
c0de106c:	0026      	movs	r6, r4
c0de106e:	465f      	mov	r7, fp
c0de1070:	40be      	lsls	r6, r7
c0de1072:	0033      	movs	r3, r6
c0de1074:	0026      	movs	r6, r4
c0de1076:	4647      	mov	r7, r8
c0de1078:	40be      	lsls	r6, r7
c0de107a:	0032      	movs	r2, r6
c0de107c:	1a80      	subs	r0, r0, r2
c0de107e:	4199      	sbcs	r1, r3
c0de1080:	9000      	str	r0, [sp, #0]
c0de1082:	9101      	str	r1, [sp, #4]
c0de1084:	e79c      	b.n	c0de0fc0 <__udivmoddi4+0x84>
c0de1086:	42a3      	cmp	r3, r4
c0de1088:	d8b9      	bhi.n	c0de0ffe <__udivmoddi4+0xc2>
c0de108a:	e780      	b.n	c0de0f8e <__udivmoddi4+0x52>
c0de108c:	4642      	mov	r2, r8
c0de108e:	2320      	movs	r3, #32
c0de1090:	2100      	movs	r1, #0
c0de1092:	1a9b      	subs	r3, r3, r2
c0de1094:	2200      	movs	r2, #0
c0de1096:	9100      	str	r1, [sp, #0]
c0de1098:	9201      	str	r2, [sp, #4]
c0de109a:	2201      	movs	r2, #1
c0de109c:	40da      	lsrs	r2, r3
c0de109e:	9201      	str	r2, [sp, #4]
c0de10a0:	e783      	b.n	c0de0faa <__udivmoddi4+0x6e>
c0de10a2:	4642      	mov	r2, r8
c0de10a4:	2320      	movs	r3, #32
c0de10a6:	1a9b      	subs	r3, r3, r2
c0de10a8:	002a      	movs	r2, r5
c0de10aa:	4646      	mov	r6, r8
c0de10ac:	409a      	lsls	r2, r3
c0de10ae:	0023      	movs	r3, r4
c0de10b0:	40f3      	lsrs	r3, r6
c0de10b2:	4644      	mov	r4, r8
c0de10b4:	4313      	orrs	r3, r2
c0de10b6:	002a      	movs	r2, r5
c0de10b8:	40e2      	lsrs	r2, r4
c0de10ba:	001c      	movs	r4, r3
c0de10bc:	465b      	mov	r3, fp
c0de10be:	0015      	movs	r5, r2
c0de10c0:	2b00      	cmp	r3, #0
c0de10c2:	dad3      	bge.n	c0de106c <__udivmoddi4+0x130>
c0de10c4:	2320      	movs	r3, #32
c0de10c6:	4642      	mov	r2, r8
c0de10c8:	0026      	movs	r6, r4
c0de10ca:	1a9b      	subs	r3, r3, r2
c0de10cc:	40de      	lsrs	r6, r3
c0de10ce:	002f      	movs	r7, r5
c0de10d0:	46b4      	mov	ip, r6
c0de10d2:	4646      	mov	r6, r8
c0de10d4:	40b7      	lsls	r7, r6
c0de10d6:	4666      	mov	r6, ip
c0de10d8:	003b      	movs	r3, r7
c0de10da:	4333      	orrs	r3, r6
c0de10dc:	e7ca      	b.n	c0de1074 <__udivmoddi4+0x138>
c0de10de:	46c0      	nop			; (mov r8, r8)

c0de10e0 <__clzdi2>:
c0de10e0:	b510      	push	{r4, lr}
c0de10e2:	2900      	cmp	r1, #0
c0de10e4:	d103      	bne.n	c0de10ee <__clzdi2+0xe>
c0de10e6:	f000 f807 	bl	c0de10f8 <__clzsi2>
c0de10ea:	3020      	adds	r0, #32
c0de10ec:	e002      	b.n	c0de10f4 <__clzdi2+0x14>
c0de10ee:	1c08      	adds	r0, r1, #0
c0de10f0:	f000 f802 	bl	c0de10f8 <__clzsi2>
c0de10f4:	bd10      	pop	{r4, pc}
c0de10f6:	46c0      	nop			; (mov r8, r8)

c0de10f8 <__clzsi2>:
c0de10f8:	211c      	movs	r1, #28
c0de10fa:	2301      	movs	r3, #1
c0de10fc:	041b      	lsls	r3, r3, #16
c0de10fe:	4298      	cmp	r0, r3
c0de1100:	d301      	bcc.n	c0de1106 <__clzsi2+0xe>
c0de1102:	0c00      	lsrs	r0, r0, #16
c0de1104:	3910      	subs	r1, #16
c0de1106:	0a1b      	lsrs	r3, r3, #8
c0de1108:	4298      	cmp	r0, r3
c0de110a:	d301      	bcc.n	c0de1110 <__clzsi2+0x18>
c0de110c:	0a00      	lsrs	r0, r0, #8
c0de110e:	3908      	subs	r1, #8
c0de1110:	091b      	lsrs	r3, r3, #4
c0de1112:	4298      	cmp	r0, r3
c0de1114:	d301      	bcc.n	c0de111a <__clzsi2+0x22>
c0de1116:	0900      	lsrs	r0, r0, #4
c0de1118:	3904      	subs	r1, #4
c0de111a:	a202      	add	r2, pc, #8	; (adr r2, c0de1124 <__clzsi2+0x2c>)
c0de111c:	5c10      	ldrb	r0, [r2, r0]
c0de111e:	1840      	adds	r0, r0, r1
c0de1120:	4770      	bx	lr
c0de1122:	46c0      	nop			; (mov r8, r8)
c0de1124:	02020304 	.word	0x02020304
c0de1128:	01010101 	.word	0x01010101
	...

c0de1134 <__aeabi_memclr>:
c0de1134:	b510      	push	{r4, lr}
c0de1136:	2200      	movs	r2, #0
c0de1138:	f000 f80a 	bl	c0de1150 <__aeabi_memset>
c0de113c:	bd10      	pop	{r4, pc}
c0de113e:	46c0      	nop			; (mov r8, r8)

c0de1140 <__aeabi_memcpy>:
c0de1140:	b510      	push	{r4, lr}
c0de1142:	f000 f835 	bl	c0de11b0 <memcpy>
c0de1146:	bd10      	pop	{r4, pc}

c0de1148 <__aeabi_memmove>:
c0de1148:	b510      	push	{r4, lr}
c0de114a:	f000 f885 	bl	c0de1258 <memmove>
c0de114e:	bd10      	pop	{r4, pc}

c0de1150 <__aeabi_memset>:
c0de1150:	0013      	movs	r3, r2
c0de1152:	b510      	push	{r4, lr}
c0de1154:	000a      	movs	r2, r1
c0de1156:	0019      	movs	r1, r3
c0de1158:	f000 f8dc 	bl	c0de1314 <memset>
c0de115c:	bd10      	pop	{r4, pc}
c0de115e:	46c0      	nop			; (mov r8, r8)

c0de1160 <memcmp>:
c0de1160:	b530      	push	{r4, r5, lr}
c0de1162:	2a03      	cmp	r2, #3
c0de1164:	d90c      	bls.n	c0de1180 <memcmp+0x20>
c0de1166:	0003      	movs	r3, r0
c0de1168:	430b      	orrs	r3, r1
c0de116a:	079b      	lsls	r3, r3, #30
c0de116c:	d11c      	bne.n	c0de11a8 <memcmp+0x48>
c0de116e:	6803      	ldr	r3, [r0, #0]
c0de1170:	680c      	ldr	r4, [r1, #0]
c0de1172:	42a3      	cmp	r3, r4
c0de1174:	d118      	bne.n	c0de11a8 <memcmp+0x48>
c0de1176:	3a04      	subs	r2, #4
c0de1178:	3004      	adds	r0, #4
c0de117a:	3104      	adds	r1, #4
c0de117c:	2a03      	cmp	r2, #3
c0de117e:	d8f6      	bhi.n	c0de116e <memcmp+0xe>
c0de1180:	1e55      	subs	r5, r2, #1
c0de1182:	2a00      	cmp	r2, #0
c0de1184:	d00e      	beq.n	c0de11a4 <memcmp+0x44>
c0de1186:	7802      	ldrb	r2, [r0, #0]
c0de1188:	780c      	ldrb	r4, [r1, #0]
c0de118a:	4294      	cmp	r4, r2
c0de118c:	d10e      	bne.n	c0de11ac <memcmp+0x4c>
c0de118e:	3501      	adds	r5, #1
c0de1190:	2301      	movs	r3, #1
c0de1192:	3901      	subs	r1, #1
c0de1194:	e004      	b.n	c0de11a0 <memcmp+0x40>
c0de1196:	5cc2      	ldrb	r2, [r0, r3]
c0de1198:	3301      	adds	r3, #1
c0de119a:	5ccc      	ldrb	r4, [r1, r3]
c0de119c:	42a2      	cmp	r2, r4
c0de119e:	d105      	bne.n	c0de11ac <memcmp+0x4c>
c0de11a0:	42ab      	cmp	r3, r5
c0de11a2:	d1f8      	bne.n	c0de1196 <memcmp+0x36>
c0de11a4:	2000      	movs	r0, #0
c0de11a6:	bd30      	pop	{r4, r5, pc}
c0de11a8:	1e55      	subs	r5, r2, #1
c0de11aa:	e7ec      	b.n	c0de1186 <memcmp+0x26>
c0de11ac:	1b10      	subs	r0, r2, r4
c0de11ae:	e7fa      	b.n	c0de11a6 <memcmp+0x46>

c0de11b0 <memcpy>:
c0de11b0:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de11b2:	46c6      	mov	lr, r8
c0de11b4:	b500      	push	{lr}
c0de11b6:	2a0f      	cmp	r2, #15
c0de11b8:	d943      	bls.n	c0de1242 <memcpy+0x92>
c0de11ba:	000b      	movs	r3, r1
c0de11bc:	2603      	movs	r6, #3
c0de11be:	4303      	orrs	r3, r0
c0de11c0:	401e      	ands	r6, r3
c0de11c2:	000c      	movs	r4, r1
c0de11c4:	0003      	movs	r3, r0
c0de11c6:	2e00      	cmp	r6, #0
c0de11c8:	d140      	bne.n	c0de124c <memcpy+0x9c>
c0de11ca:	0015      	movs	r5, r2
c0de11cc:	3d10      	subs	r5, #16
c0de11ce:	092d      	lsrs	r5, r5, #4
c0de11d0:	46ac      	mov	ip, r5
c0de11d2:	012d      	lsls	r5, r5, #4
c0de11d4:	46a8      	mov	r8, r5
c0de11d6:	4480      	add	r8, r0
c0de11d8:	e000      	b.n	c0de11dc <memcpy+0x2c>
c0de11da:	003b      	movs	r3, r7
c0de11dc:	6867      	ldr	r7, [r4, #4]
c0de11de:	6825      	ldr	r5, [r4, #0]
c0de11e0:	605f      	str	r7, [r3, #4]
c0de11e2:	68e7      	ldr	r7, [r4, #12]
c0de11e4:	601d      	str	r5, [r3, #0]
c0de11e6:	60df      	str	r7, [r3, #12]
c0de11e8:	001f      	movs	r7, r3
c0de11ea:	68a5      	ldr	r5, [r4, #8]
c0de11ec:	3710      	adds	r7, #16
c0de11ee:	609d      	str	r5, [r3, #8]
c0de11f0:	3410      	adds	r4, #16
c0de11f2:	4543      	cmp	r3, r8
c0de11f4:	d1f1      	bne.n	c0de11da <memcpy+0x2a>
c0de11f6:	4665      	mov	r5, ip
c0de11f8:	230f      	movs	r3, #15
c0de11fa:	240c      	movs	r4, #12
c0de11fc:	3501      	adds	r5, #1
c0de11fe:	012d      	lsls	r5, r5, #4
c0de1200:	1949      	adds	r1, r1, r5
c0de1202:	4013      	ands	r3, r2
c0de1204:	1945      	adds	r5, r0, r5
c0de1206:	4214      	tst	r4, r2
c0de1208:	d023      	beq.n	c0de1252 <memcpy+0xa2>
c0de120a:	598c      	ldr	r4, [r1, r6]
c0de120c:	51ac      	str	r4, [r5, r6]
c0de120e:	3604      	adds	r6, #4
c0de1210:	1b9c      	subs	r4, r3, r6
c0de1212:	2c03      	cmp	r4, #3
c0de1214:	d8f9      	bhi.n	c0de120a <memcpy+0x5a>
c0de1216:	2403      	movs	r4, #3
c0de1218:	3b04      	subs	r3, #4
c0de121a:	089b      	lsrs	r3, r3, #2
c0de121c:	3301      	adds	r3, #1
c0de121e:	009b      	lsls	r3, r3, #2
c0de1220:	4022      	ands	r2, r4
c0de1222:	18ed      	adds	r5, r5, r3
c0de1224:	18c9      	adds	r1, r1, r3
c0de1226:	1e56      	subs	r6, r2, #1
c0de1228:	2a00      	cmp	r2, #0
c0de122a:	d007      	beq.n	c0de123c <memcpy+0x8c>
c0de122c:	2300      	movs	r3, #0
c0de122e:	e000      	b.n	c0de1232 <memcpy+0x82>
c0de1230:	0023      	movs	r3, r4
c0de1232:	5cca      	ldrb	r2, [r1, r3]
c0de1234:	1c5c      	adds	r4, r3, #1
c0de1236:	54ea      	strb	r2, [r5, r3]
c0de1238:	429e      	cmp	r6, r3
c0de123a:	d1f9      	bne.n	c0de1230 <memcpy+0x80>
c0de123c:	bc04      	pop	{r2}
c0de123e:	4690      	mov	r8, r2
c0de1240:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0de1242:	0005      	movs	r5, r0
c0de1244:	1e56      	subs	r6, r2, #1
c0de1246:	2a00      	cmp	r2, #0
c0de1248:	d1f0      	bne.n	c0de122c <memcpy+0x7c>
c0de124a:	e7f7      	b.n	c0de123c <memcpy+0x8c>
c0de124c:	1e56      	subs	r6, r2, #1
c0de124e:	0005      	movs	r5, r0
c0de1250:	e7ec      	b.n	c0de122c <memcpy+0x7c>
c0de1252:	001a      	movs	r2, r3
c0de1254:	e7f6      	b.n	c0de1244 <memcpy+0x94>
c0de1256:	46c0      	nop			; (mov r8, r8)

c0de1258 <memmove>:
c0de1258:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de125a:	46c6      	mov	lr, r8
c0de125c:	b500      	push	{lr}
c0de125e:	4288      	cmp	r0, r1
c0de1260:	d90c      	bls.n	c0de127c <memmove+0x24>
c0de1262:	188b      	adds	r3, r1, r2
c0de1264:	4298      	cmp	r0, r3
c0de1266:	d209      	bcs.n	c0de127c <memmove+0x24>
c0de1268:	1e53      	subs	r3, r2, #1
c0de126a:	2a00      	cmp	r2, #0
c0de126c:	d003      	beq.n	c0de1276 <memmove+0x1e>
c0de126e:	5cca      	ldrb	r2, [r1, r3]
c0de1270:	54c2      	strb	r2, [r0, r3]
c0de1272:	3b01      	subs	r3, #1
c0de1274:	d2fb      	bcs.n	c0de126e <memmove+0x16>
c0de1276:	bc04      	pop	{r2}
c0de1278:	4690      	mov	r8, r2
c0de127a:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0de127c:	2a0f      	cmp	r2, #15
c0de127e:	d80c      	bhi.n	c0de129a <memmove+0x42>
c0de1280:	0005      	movs	r5, r0
c0de1282:	1e56      	subs	r6, r2, #1
c0de1284:	2a00      	cmp	r2, #0
c0de1286:	d0f6      	beq.n	c0de1276 <memmove+0x1e>
c0de1288:	2300      	movs	r3, #0
c0de128a:	e000      	b.n	c0de128e <memmove+0x36>
c0de128c:	0023      	movs	r3, r4
c0de128e:	5cca      	ldrb	r2, [r1, r3]
c0de1290:	1c5c      	adds	r4, r3, #1
c0de1292:	54ea      	strb	r2, [r5, r3]
c0de1294:	429e      	cmp	r6, r3
c0de1296:	d1f9      	bne.n	c0de128c <memmove+0x34>
c0de1298:	e7ed      	b.n	c0de1276 <memmove+0x1e>
c0de129a:	000b      	movs	r3, r1
c0de129c:	2603      	movs	r6, #3
c0de129e:	4303      	orrs	r3, r0
c0de12a0:	401e      	ands	r6, r3
c0de12a2:	000c      	movs	r4, r1
c0de12a4:	0003      	movs	r3, r0
c0de12a6:	2e00      	cmp	r6, #0
c0de12a8:	d12e      	bne.n	c0de1308 <memmove+0xb0>
c0de12aa:	0015      	movs	r5, r2
c0de12ac:	3d10      	subs	r5, #16
c0de12ae:	092d      	lsrs	r5, r5, #4
c0de12b0:	46ac      	mov	ip, r5
c0de12b2:	012d      	lsls	r5, r5, #4
c0de12b4:	46a8      	mov	r8, r5
c0de12b6:	4480      	add	r8, r0
c0de12b8:	e000      	b.n	c0de12bc <memmove+0x64>
c0de12ba:	002b      	movs	r3, r5
c0de12bc:	001d      	movs	r5, r3
c0de12be:	6827      	ldr	r7, [r4, #0]
c0de12c0:	3510      	adds	r5, #16
c0de12c2:	601f      	str	r7, [r3, #0]
c0de12c4:	6867      	ldr	r7, [r4, #4]
c0de12c6:	605f      	str	r7, [r3, #4]
c0de12c8:	68a7      	ldr	r7, [r4, #8]
c0de12ca:	609f      	str	r7, [r3, #8]
c0de12cc:	68e7      	ldr	r7, [r4, #12]
c0de12ce:	3410      	adds	r4, #16
c0de12d0:	60df      	str	r7, [r3, #12]
c0de12d2:	4543      	cmp	r3, r8
c0de12d4:	d1f1      	bne.n	c0de12ba <memmove+0x62>
c0de12d6:	4665      	mov	r5, ip
c0de12d8:	230f      	movs	r3, #15
c0de12da:	240c      	movs	r4, #12
c0de12dc:	3501      	adds	r5, #1
c0de12de:	012d      	lsls	r5, r5, #4
c0de12e0:	1949      	adds	r1, r1, r5
c0de12e2:	4013      	ands	r3, r2
c0de12e4:	1945      	adds	r5, r0, r5
c0de12e6:	4214      	tst	r4, r2
c0de12e8:	d011      	beq.n	c0de130e <memmove+0xb6>
c0de12ea:	598c      	ldr	r4, [r1, r6]
c0de12ec:	51ac      	str	r4, [r5, r6]
c0de12ee:	3604      	adds	r6, #4
c0de12f0:	1b9c      	subs	r4, r3, r6
c0de12f2:	2c03      	cmp	r4, #3
c0de12f4:	d8f9      	bhi.n	c0de12ea <memmove+0x92>
c0de12f6:	2403      	movs	r4, #3
c0de12f8:	3b04      	subs	r3, #4
c0de12fa:	089b      	lsrs	r3, r3, #2
c0de12fc:	3301      	adds	r3, #1
c0de12fe:	009b      	lsls	r3, r3, #2
c0de1300:	18ed      	adds	r5, r5, r3
c0de1302:	18c9      	adds	r1, r1, r3
c0de1304:	4022      	ands	r2, r4
c0de1306:	e7bc      	b.n	c0de1282 <memmove+0x2a>
c0de1308:	1e56      	subs	r6, r2, #1
c0de130a:	0005      	movs	r5, r0
c0de130c:	e7bc      	b.n	c0de1288 <memmove+0x30>
c0de130e:	001a      	movs	r2, r3
c0de1310:	e7b7      	b.n	c0de1282 <memmove+0x2a>
c0de1312:	46c0      	nop			; (mov r8, r8)

c0de1314 <memset>:
c0de1314:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de1316:	0005      	movs	r5, r0
c0de1318:	0783      	lsls	r3, r0, #30
c0de131a:	d04a      	beq.n	c0de13b2 <memset+0x9e>
c0de131c:	1e54      	subs	r4, r2, #1
c0de131e:	2a00      	cmp	r2, #0
c0de1320:	d044      	beq.n	c0de13ac <memset+0x98>
c0de1322:	b2ce      	uxtb	r6, r1
c0de1324:	0003      	movs	r3, r0
c0de1326:	2203      	movs	r2, #3
c0de1328:	e002      	b.n	c0de1330 <memset+0x1c>
c0de132a:	3501      	adds	r5, #1
c0de132c:	3c01      	subs	r4, #1
c0de132e:	d33d      	bcc.n	c0de13ac <memset+0x98>
c0de1330:	3301      	adds	r3, #1
c0de1332:	702e      	strb	r6, [r5, #0]
c0de1334:	4213      	tst	r3, r2
c0de1336:	d1f8      	bne.n	c0de132a <memset+0x16>
c0de1338:	2c03      	cmp	r4, #3
c0de133a:	d92f      	bls.n	c0de139c <memset+0x88>
c0de133c:	22ff      	movs	r2, #255	; 0xff
c0de133e:	400a      	ands	r2, r1
c0de1340:	0215      	lsls	r5, r2, #8
c0de1342:	4315      	orrs	r5, r2
c0de1344:	042a      	lsls	r2, r5, #16
c0de1346:	4315      	orrs	r5, r2
c0de1348:	2c0f      	cmp	r4, #15
c0de134a:	d935      	bls.n	c0de13b8 <memset+0xa4>
c0de134c:	0027      	movs	r7, r4
c0de134e:	3f10      	subs	r7, #16
c0de1350:	093f      	lsrs	r7, r7, #4
c0de1352:	013e      	lsls	r6, r7, #4
c0de1354:	46b4      	mov	ip, r6
c0de1356:	001e      	movs	r6, r3
c0de1358:	001a      	movs	r2, r3
c0de135a:	3610      	adds	r6, #16
c0de135c:	4466      	add	r6, ip
c0de135e:	6015      	str	r5, [r2, #0]
c0de1360:	6055      	str	r5, [r2, #4]
c0de1362:	6095      	str	r5, [r2, #8]
c0de1364:	60d5      	str	r5, [r2, #12]
c0de1366:	3210      	adds	r2, #16
c0de1368:	42b2      	cmp	r2, r6
c0de136a:	d1f8      	bne.n	c0de135e <memset+0x4a>
c0de136c:	260f      	movs	r6, #15
c0de136e:	220c      	movs	r2, #12
c0de1370:	3701      	adds	r7, #1
c0de1372:	013f      	lsls	r7, r7, #4
c0de1374:	4026      	ands	r6, r4
c0de1376:	19db      	adds	r3, r3, r7
c0de1378:	0037      	movs	r7, r6
c0de137a:	4222      	tst	r2, r4
c0de137c:	d017      	beq.n	c0de13ae <memset+0x9a>
c0de137e:	1f3e      	subs	r6, r7, #4
c0de1380:	08b6      	lsrs	r6, r6, #2
c0de1382:	00b4      	lsls	r4, r6, #2
c0de1384:	46a4      	mov	ip, r4
c0de1386:	001a      	movs	r2, r3
c0de1388:	1d1c      	adds	r4, r3, #4
c0de138a:	4464      	add	r4, ip
c0de138c:	c220      	stmia	r2!, {r5}
c0de138e:	42a2      	cmp	r2, r4
c0de1390:	d1fc      	bne.n	c0de138c <memset+0x78>
c0de1392:	2403      	movs	r4, #3
c0de1394:	3601      	adds	r6, #1
c0de1396:	00b6      	lsls	r6, r6, #2
c0de1398:	199b      	adds	r3, r3, r6
c0de139a:	403c      	ands	r4, r7
c0de139c:	2c00      	cmp	r4, #0
c0de139e:	d005      	beq.n	c0de13ac <memset+0x98>
c0de13a0:	b2c9      	uxtb	r1, r1
c0de13a2:	191c      	adds	r4, r3, r4
c0de13a4:	7019      	strb	r1, [r3, #0]
c0de13a6:	3301      	adds	r3, #1
c0de13a8:	429c      	cmp	r4, r3
c0de13aa:	d1fb      	bne.n	c0de13a4 <memset+0x90>
c0de13ac:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0de13ae:	0034      	movs	r4, r6
c0de13b0:	e7f4      	b.n	c0de139c <memset+0x88>
c0de13b2:	0014      	movs	r4, r2
c0de13b4:	0003      	movs	r3, r0
c0de13b6:	e7bf      	b.n	c0de1338 <memset+0x24>
c0de13b8:	0027      	movs	r7, r4
c0de13ba:	e7e0      	b.n	c0de137e <memset+0x6a>

c0de13bc <setjmp>:
c0de13bc:	c0f0      	stmia	r0!, {r4, r5, r6, r7}
c0de13be:	4641      	mov	r1, r8
c0de13c0:	464a      	mov	r2, r9
c0de13c2:	4653      	mov	r3, sl
c0de13c4:	465c      	mov	r4, fp
c0de13c6:	466d      	mov	r5, sp
c0de13c8:	4676      	mov	r6, lr
c0de13ca:	c07e      	stmia	r0!, {r1, r2, r3, r4, r5, r6}
c0de13cc:	3828      	subs	r0, #40	; 0x28
c0de13ce:	c8f0      	ldmia	r0!, {r4, r5, r6, r7}
c0de13d0:	2000      	movs	r0, #0
c0de13d2:	4770      	bx	lr

c0de13d4 <longjmp>:
c0de13d4:	3010      	adds	r0, #16
c0de13d6:	c87c      	ldmia	r0!, {r2, r3, r4, r5, r6}
c0de13d8:	4690      	mov	r8, r2
c0de13da:	4699      	mov	r9, r3
c0de13dc:	46a2      	mov	sl, r4
c0de13de:	46ab      	mov	fp, r5
c0de13e0:	46b5      	mov	sp, r6
c0de13e2:	c808      	ldmia	r0!, {r3}
c0de13e4:	3828      	subs	r0, #40	; 0x28
c0de13e6:	c8f0      	ldmia	r0!, {r4, r5, r6, r7}
c0de13e8:	1c08      	adds	r0, r1, #0
c0de13ea:	d100      	bne.n	c0de13ee <longjmp+0x1a>
c0de13ec:	2001      	movs	r0, #1
c0de13ee:	4718      	bx	r3

c0de13f0 <strlcat>:
c0de13f0:	b570      	push	{r4, r5, r6, lr}
c0de13f2:	2a00      	cmp	r2, #0
c0de13f4:	d02a      	beq.n	c0de144c <strlcat+0x5c>
c0de13f6:	7803      	ldrb	r3, [r0, #0]
c0de13f8:	2b00      	cmp	r3, #0
c0de13fa:	d029      	beq.n	c0de1450 <strlcat+0x60>
c0de13fc:	1884      	adds	r4, r0, r2
c0de13fe:	0003      	movs	r3, r0
c0de1400:	e002      	b.n	c0de1408 <strlcat+0x18>
c0de1402:	781d      	ldrb	r5, [r3, #0]
c0de1404:	2d00      	cmp	r5, #0
c0de1406:	d018      	beq.n	c0de143a <strlcat+0x4a>
c0de1408:	3301      	adds	r3, #1
c0de140a:	42a3      	cmp	r3, r4
c0de140c:	d1f9      	bne.n	c0de1402 <strlcat+0x12>
c0de140e:	1a26      	subs	r6, r4, r0
c0de1410:	1b92      	subs	r2, r2, r6
c0de1412:	d016      	beq.n	c0de1442 <strlcat+0x52>
c0de1414:	780d      	ldrb	r5, [r1, #0]
c0de1416:	000b      	movs	r3, r1
c0de1418:	2d00      	cmp	r5, #0
c0de141a:	d00a      	beq.n	c0de1432 <strlcat+0x42>
c0de141c:	2a01      	cmp	r2, #1
c0de141e:	d002      	beq.n	c0de1426 <strlcat+0x36>
c0de1420:	7025      	strb	r5, [r4, #0]
c0de1422:	3a01      	subs	r2, #1
c0de1424:	3401      	adds	r4, #1
c0de1426:	3301      	adds	r3, #1
c0de1428:	781d      	ldrb	r5, [r3, #0]
c0de142a:	2d00      	cmp	r5, #0
c0de142c:	d1f6      	bne.n	c0de141c <strlcat+0x2c>
c0de142e:	1a5b      	subs	r3, r3, r1
c0de1430:	18f6      	adds	r6, r6, r3
c0de1432:	2300      	movs	r3, #0
c0de1434:	7023      	strb	r3, [r4, #0]
c0de1436:	0030      	movs	r0, r6
c0de1438:	bd70      	pop	{r4, r5, r6, pc}
c0de143a:	001c      	movs	r4, r3
c0de143c:	1a26      	subs	r6, r4, r0
c0de143e:	1b92      	subs	r2, r2, r6
c0de1440:	d1e8      	bne.n	c0de1414 <strlcat+0x24>
c0de1442:	0008      	movs	r0, r1
c0de1444:	f000 f82e 	bl	c0de14a4 <strlen>
c0de1448:	1836      	adds	r6, r6, r0
c0de144a:	e7f4      	b.n	c0de1436 <strlcat+0x46>
c0de144c:	2600      	movs	r6, #0
c0de144e:	e7f8      	b.n	c0de1442 <strlcat+0x52>
c0de1450:	0004      	movs	r4, r0
c0de1452:	2600      	movs	r6, #0
c0de1454:	e7de      	b.n	c0de1414 <strlcat+0x24>
c0de1456:	46c0      	nop			; (mov r8, r8)

c0de1458 <strlcpy>:
c0de1458:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de145a:	2a00      	cmp	r2, #0
c0de145c:	d013      	beq.n	c0de1486 <strlcpy+0x2e>
c0de145e:	3a01      	subs	r2, #1
c0de1460:	2a00      	cmp	r2, #0
c0de1462:	d019      	beq.n	c0de1498 <strlcpy+0x40>
c0de1464:	2300      	movs	r3, #0
c0de1466:	1c4f      	adds	r7, r1, #1
c0de1468:	1c46      	adds	r6, r0, #1
c0de146a:	e002      	b.n	c0de1472 <strlcpy+0x1a>
c0de146c:	3301      	adds	r3, #1
c0de146e:	429a      	cmp	r2, r3
c0de1470:	d016      	beq.n	c0de14a0 <strlcpy+0x48>
c0de1472:	18f5      	adds	r5, r6, r3
c0de1474:	46ac      	mov	ip, r5
c0de1476:	5ccd      	ldrb	r5, [r1, r3]
c0de1478:	18fc      	adds	r4, r7, r3
c0de147a:	54c5      	strb	r5, [r0, r3]
c0de147c:	2d00      	cmp	r5, #0
c0de147e:	d1f5      	bne.n	c0de146c <strlcpy+0x14>
c0de1480:	1a60      	subs	r0, r4, r1
c0de1482:	3801      	subs	r0, #1
c0de1484:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0de1486:	000c      	movs	r4, r1
c0de1488:	0023      	movs	r3, r4
c0de148a:	3301      	adds	r3, #1
c0de148c:	1e5a      	subs	r2, r3, #1
c0de148e:	7812      	ldrb	r2, [r2, #0]
c0de1490:	001c      	movs	r4, r3
c0de1492:	2a00      	cmp	r2, #0
c0de1494:	d1f9      	bne.n	c0de148a <strlcpy+0x32>
c0de1496:	e7f3      	b.n	c0de1480 <strlcpy+0x28>
c0de1498:	000c      	movs	r4, r1
c0de149a:	2300      	movs	r3, #0
c0de149c:	7003      	strb	r3, [r0, #0]
c0de149e:	e7f3      	b.n	c0de1488 <strlcpy+0x30>
c0de14a0:	4660      	mov	r0, ip
c0de14a2:	e7fa      	b.n	c0de149a <strlcpy+0x42>

c0de14a4 <strlen>:
c0de14a4:	b510      	push	{r4, lr}
c0de14a6:	0783      	lsls	r3, r0, #30
c0de14a8:	d027      	beq.n	c0de14fa <strlen+0x56>
c0de14aa:	7803      	ldrb	r3, [r0, #0]
c0de14ac:	2b00      	cmp	r3, #0
c0de14ae:	d026      	beq.n	c0de14fe <strlen+0x5a>
c0de14b0:	0003      	movs	r3, r0
c0de14b2:	2103      	movs	r1, #3
c0de14b4:	e002      	b.n	c0de14bc <strlen+0x18>
c0de14b6:	781a      	ldrb	r2, [r3, #0]
c0de14b8:	2a00      	cmp	r2, #0
c0de14ba:	d01c      	beq.n	c0de14f6 <strlen+0x52>
c0de14bc:	3301      	adds	r3, #1
c0de14be:	420b      	tst	r3, r1
c0de14c0:	d1f9      	bne.n	c0de14b6 <strlen+0x12>
c0de14c2:	6819      	ldr	r1, [r3, #0]
c0de14c4:	4a0f      	ldr	r2, [pc, #60]	; (c0de1504 <strlen+0x60>)
c0de14c6:	4c10      	ldr	r4, [pc, #64]	; (c0de1508 <strlen+0x64>)
c0de14c8:	188a      	adds	r2, r1, r2
c0de14ca:	438a      	bics	r2, r1
c0de14cc:	4222      	tst	r2, r4
c0de14ce:	d10f      	bne.n	c0de14f0 <strlen+0x4c>
c0de14d0:	3304      	adds	r3, #4
c0de14d2:	6819      	ldr	r1, [r3, #0]
c0de14d4:	4a0b      	ldr	r2, [pc, #44]	; (c0de1504 <strlen+0x60>)
c0de14d6:	188a      	adds	r2, r1, r2
c0de14d8:	438a      	bics	r2, r1
c0de14da:	4222      	tst	r2, r4
c0de14dc:	d108      	bne.n	c0de14f0 <strlen+0x4c>
c0de14de:	3304      	adds	r3, #4
c0de14e0:	6819      	ldr	r1, [r3, #0]
c0de14e2:	4a08      	ldr	r2, [pc, #32]	; (c0de1504 <strlen+0x60>)
c0de14e4:	188a      	adds	r2, r1, r2
c0de14e6:	438a      	bics	r2, r1
c0de14e8:	4222      	tst	r2, r4
c0de14ea:	d0f1      	beq.n	c0de14d0 <strlen+0x2c>
c0de14ec:	e000      	b.n	c0de14f0 <strlen+0x4c>
c0de14ee:	3301      	adds	r3, #1
c0de14f0:	781a      	ldrb	r2, [r3, #0]
c0de14f2:	2a00      	cmp	r2, #0
c0de14f4:	d1fb      	bne.n	c0de14ee <strlen+0x4a>
c0de14f6:	1a18      	subs	r0, r3, r0
c0de14f8:	bd10      	pop	{r4, pc}
c0de14fa:	0003      	movs	r3, r0
c0de14fc:	e7e1      	b.n	c0de14c2 <strlen+0x1e>
c0de14fe:	2000      	movs	r0, #0
c0de1500:	e7fa      	b.n	c0de14f8 <strlen+0x54>
c0de1502:	46c0      	nop			; (mov r8, r8)
c0de1504:	fefefeff 	.word	0xfefefeff
c0de1508:	80808080 	.word	0x80808080

c0de150c <strnlen>:
c0de150c:	b510      	push	{r4, lr}
c0de150e:	2900      	cmp	r1, #0
c0de1510:	d00b      	beq.n	c0de152a <strnlen+0x1e>
c0de1512:	7803      	ldrb	r3, [r0, #0]
c0de1514:	2b00      	cmp	r3, #0
c0de1516:	d00c      	beq.n	c0de1532 <strnlen+0x26>
c0de1518:	1844      	adds	r4, r0, r1
c0de151a:	0003      	movs	r3, r0
c0de151c:	e002      	b.n	c0de1524 <strnlen+0x18>
c0de151e:	781a      	ldrb	r2, [r3, #0]
c0de1520:	2a00      	cmp	r2, #0
c0de1522:	d004      	beq.n	c0de152e <strnlen+0x22>
c0de1524:	3301      	adds	r3, #1
c0de1526:	42a3      	cmp	r3, r4
c0de1528:	d1f9      	bne.n	c0de151e <strnlen+0x12>
c0de152a:	0008      	movs	r0, r1
c0de152c:	bd10      	pop	{r4, pc}
c0de152e:	1a19      	subs	r1, r3, r0
c0de1530:	e7fb      	b.n	c0de152a <strnlen+0x1e>
c0de1532:	2100      	movs	r1, #0
c0de1534:	e7f9      	b.n	c0de152a <strnlen+0x1e>
c0de1536:	46c0      	nop			; (mov r8, r8)

c0de1538 <HARVEST_SELECTORS>:
c0de1538:	5f25 b6b5 7d4d 2e1a fc3a a694 b912 3d18     %_..M}..:......=
c0de1548:	d8ee e9fa 3bd9 916a 4144 0049 6c50 6775     .....;j.DAI.Plug
c0de1558:	6e69 7020 7261 6d61 7465 7265 2073 7473     in parameters st
c0de1568:	7572 7463 7275 2065 7369 6220 6769 6567     ructure is bigge
c0de1578:	2072 6874 6e61 6120 6c6c 776f 6465 7320     r than allowed s
c0de1588:	7a69 0a65 3000 3178 6435 4133 3436 3242     ize..0x15d3A64B2
c0de1598:	3564 6261 4539 3531 4632 3631 3935 4333     d5ab9E152F16593C
c0de15a8:	6564 6362 6234 3142 3536 3542 3442 0041     debc4bB165B5B4A.
c0de15b8:	6553 656c 7463 726f 6920 646e 7865 203a     Selector index: 
c0de15c8:	6425 6e20 746f 7320 7075 6f70 7472 6465     %d not supported
c0de15d8:	000a 7830 3066 3533 6538 6338 4333 3544     ..0xf0358e8c3CD5
c0de15e8:	6146 3332 6138 3932 3033 6431 6230 6145     Fa238a29301d0bEa
c0de15f8:	4433 3336 3141 6237 6445 4542 5000 6f6f     3D63A17bEdBE.Poo
c0de1608:	006c 6d41 756f 746e 2000 3000 6178 3762     l.Amount. .0xab7
c0de1618:	4146 4232 3932 3538 4342 6663 3143 6333     FA2B2985BCcfC13c
c0de1628:	4436 3638 3162 3544 3141 3437 3638 6261     6D86b1D5A17486ab
c0de1638:	6531 3430 0043 3025 7832 4800 7261 6576     1e04C.%02x.Harve
c0de1648:	7473 5600 7561 746c 5500 4453 0043 7445     st.Vault.USDC.Et
c0de1658:	6568 6572 6d75 4300 616c 6d69 3000 5000     hereum.Claim.0.P
c0de1668:	7261 6d61 6e20 746f 7320 7075 6f70 7472     aram not support
c0de1678:	6465 203a 6425 000a 7453 6b61 0065 7845     ed: %d..Stake.Ex
c0de1688:	6563 7470 6f69 206e 7830 7825 6320 7561     ception 0x%x cau
c0de1698:	6867 0a74 4500 6978 0074                    ght..Exit.

c0de16a2 <HEXDIGITS>:
c0de16a2:	3130 3332 3534 3736 3938 6261 6463 6665     0123456789abcdef
c0de16b2:	6500 6378 7065 6974 6e6f 255b 5d64 203a     .exception[%d]: 
c0de16c2:	524c 303d 2578 3830 0a58 4500 5252 524f     LR=0x%08X..ERROR
c0de16d2:	3000 0078 6553 656c 7463 726f 4920 646e     .0x.Selector Ind
c0de16e2:	7865 6e20 746f 7320 7075 6f70 7472 6465     ex not supported
c0de16f2:	203a 6425 000a 6e55 6168 646e 656c 2064     : %d..Unhandled 
c0de1702:	656d 7373 6761 2065 6425 000a 6f43 746e     message %d..Cont
c0de1712:	6172 7463 2073 656c 676e 6874 203a 6425     racts length: %d
c0de1722:	000a 4466 4941 0a00 6600 5355 4344 4600     ..fDAI...fUSDC.F
c0de1732:	4f52 5f4d 4d41 554f 544e 203a 5700 6469     ROM_AMOUNT: .Wid
c0de1742:	206f 7845 6365 7475 0065 6552 6563 7669     o Execute.Receiv
c0de1752:	6465 6120 206e 6e69 6176 696c 2064 6373     ed an invalid sc
c0de1762:	6572 6e65 6e49 6564 0a78 7000 756c 6967     reenIndex..plugi
c0de1772:	206e 7270 766f 6469 2065 6170 6172 656d     n provide parame
c0de1782:	6574 3a72 6f20 6666 6573 2074 6425 420a     ter: offset %d.B
c0de1792:	7479 7365 203a 2e25 482a 000a 6957 6874     ytes: %.*H..With
c0de17a2:	7264 7761 0000 534d 2047 6441 7264 7365     draw..MSG Addres
c0de17b2:	3a73 2520 0a73 4400 7065 736f 7469 4d00     s: %s..Deposit.M
c0de17c2:	7369 6973 676e 7320 6c65 6365 6f74 4972     issing selectorI
c0de17d2:	646e 7865 203a 6425 000a 6957 6f64 3000     ndex: %d..Wido.0
c0de17e2:	3478 3746 3263 6338 6243 4630 4431 6462     x4F7c28cCb0F1Dbd
c0de17f2:	3331 3838 3032 4339 3736 4565 3263 3433     1388209C67eEc234
c0de1802:	3732 4333 3738 4238 0064                    273C878Bd.

c0de180c <contracts>:
c0de180c:	1613 c0de 1550 c0de 0012 0000 1724 c0de     ....P.......$...
c0de181c:	0012 0000 158d c0de 1724 c0de 0012 0000     ........$.......
c0de182c:	17a7 c0de 0012 0000 15da c0de 1651 c0de     ............Q...
c0de183c:	0006 0000 172b c0de 0012 0000 17e1 c0de     ....+...........
c0de184c:	172b c0de 0012 0000 17a7 c0de 0012 0000     +...............

c0de185c <g_pcHex>:
c0de185c:	3130 3332 3534 3736 3938 6261 6463 6665     0123456789abcdef

c0de186c <g_pcHex_cap>:
c0de186c:	3130 3332 3534 3736 3938 4241 4443 4645     0123456789ABCDEF

c0de187c <_etext>:
c0de187c:	d4d4      	bmi.n	c0de1828 <contracts+0x1c>
c0de187e:	d4d4      	bmi.n	c0de182a <contracts+0x1e>
c0de1880:	d4d4      	bmi.n	c0de182c <contracts+0x20>
c0de1882:	d4d4      	bmi.n	c0de182e <contracts+0x22>
c0de1884:	d4d4      	bmi.n	c0de1830 <contracts+0x24>
c0de1886:	d4d4      	bmi.n	c0de1832 <contracts+0x26>
c0de1888:	d4d4      	bmi.n	c0de1834 <contracts+0x28>
c0de188a:	d4d4      	bmi.n	c0de1836 <contracts+0x2a>
c0de188c:	d4d4      	bmi.n	c0de1838 <contracts+0x2c>
c0de188e:	d4d4      	bmi.n	c0de183a <contracts+0x2e>
c0de1890:	d4d4      	bmi.n	c0de183c <contracts+0x30>
c0de1892:	d4d4      	bmi.n	c0de183e <contracts+0x32>
c0de1894:	d4d4      	bmi.n	c0de1840 <contracts+0x34>
c0de1896:	d4d4      	bmi.n	c0de1842 <contracts+0x36>
c0de1898:	d4d4      	bmi.n	c0de1844 <contracts+0x38>
c0de189a:	d4d4      	bmi.n	c0de1846 <contracts+0x3a>
c0de189c:	d4d4      	bmi.n	c0de1848 <contracts+0x3c>
c0de189e:	d4d4      	bmi.n	c0de184a <contracts+0x3e>
c0de18a0:	d4d4      	bmi.n	c0de184c <contracts+0x40>
c0de18a2:	d4d4      	bmi.n	c0de184e <contracts+0x42>
c0de18a4:	d4d4      	bmi.n	c0de1850 <contracts+0x44>
c0de18a6:	d4d4      	bmi.n	c0de1852 <contracts+0x46>
c0de18a8:	d4d4      	bmi.n	c0de1854 <contracts+0x48>
c0de18aa:	d4d4      	bmi.n	c0de1856 <contracts+0x4a>
c0de18ac:	d4d4      	bmi.n	c0de1858 <contracts+0x4c>
c0de18ae:	d4d4      	bmi.n	c0de185a <contracts+0x4e>
c0de18b0:	d4d4      	bmi.n	c0de185c <g_pcHex>
c0de18b2:	d4d4      	bmi.n	c0de185e <g_pcHex+0x2>
c0de18b4:	d4d4      	bmi.n	c0de1860 <g_pcHex+0x4>
c0de18b6:	d4d4      	bmi.n	c0de1862 <g_pcHex+0x6>
c0de18b8:	d4d4      	bmi.n	c0de1864 <g_pcHex+0x8>
c0de18ba:	d4d4      	bmi.n	c0de1866 <g_pcHex+0xa>
c0de18bc:	d4d4      	bmi.n	c0de1868 <g_pcHex+0xc>
c0de18be:	d4d4      	bmi.n	c0de186a <g_pcHex+0xe>
c0de18c0:	d4d4      	bmi.n	c0de186c <g_pcHex_cap>
c0de18c2:	d4d4      	bmi.n	c0de186e <g_pcHex_cap+0x2>
c0de18c4:	d4d4      	bmi.n	c0de1870 <g_pcHex_cap+0x4>
c0de18c6:	d4d4      	bmi.n	c0de1872 <g_pcHex_cap+0x6>
c0de18c8:	d4d4      	bmi.n	c0de1874 <g_pcHex_cap+0x8>
c0de18ca:	d4d4      	bmi.n	c0de1876 <g_pcHex_cap+0xa>
c0de18cc:	d4d4      	bmi.n	c0de1878 <g_pcHex_cap+0xc>
c0de18ce:	d4d4      	bmi.n	c0de187a <g_pcHex_cap+0xe>
c0de18d0:	d4d4      	bmi.n	c0de187c <_etext>
c0de18d2:	d4d4      	bmi.n	c0de187e <_etext+0x2>
c0de18d4:	d4d4      	bmi.n	c0de1880 <_etext+0x4>
c0de18d6:	d4d4      	bmi.n	c0de1882 <_etext+0x6>
c0de18d8:	d4d4      	bmi.n	c0de1884 <_etext+0x8>
c0de18da:	d4d4      	bmi.n	c0de1886 <_etext+0xa>
c0de18dc:	d4d4      	bmi.n	c0de1888 <_etext+0xc>
c0de18de:	d4d4      	bmi.n	c0de188a <_etext+0xe>
c0de18e0:	d4d4      	bmi.n	c0de188c <_etext+0x10>
c0de18e2:	d4d4      	bmi.n	c0de188e <_etext+0x12>
c0de18e4:	d4d4      	bmi.n	c0de1890 <_etext+0x14>
c0de18e6:	d4d4      	bmi.n	c0de1892 <_etext+0x16>
c0de18e8:	d4d4      	bmi.n	c0de1894 <_etext+0x18>
c0de18ea:	d4d4      	bmi.n	c0de1896 <_etext+0x1a>
c0de18ec:	d4d4      	bmi.n	c0de1898 <_etext+0x1c>
c0de18ee:	d4d4      	bmi.n	c0de189a <_etext+0x1e>
c0de18f0:	d4d4      	bmi.n	c0de189c <_etext+0x20>
c0de18f2:	d4d4      	bmi.n	c0de189e <_etext+0x22>
c0de18f4:	d4d4      	bmi.n	c0de18a0 <_etext+0x24>
c0de18f6:	d4d4      	bmi.n	c0de18a2 <_etext+0x26>
c0de18f8:	d4d4      	bmi.n	c0de18a4 <_etext+0x28>
c0de18fa:	d4d4      	bmi.n	c0de18a6 <_etext+0x2a>
c0de18fc:	d4d4      	bmi.n	c0de18a8 <_etext+0x2c>
c0de18fe:	d4d4      	bmi.n	c0de18aa <_etext+0x2e>
