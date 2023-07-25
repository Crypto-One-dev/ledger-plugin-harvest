import { addressbook } from "./constants";
import { testRawTx, testTx } from "./tools";

const method = 'executeOrder(((address,uint256)[],(address,uint256)[],address,uint32,uint32),(address,address,bytes,int32)[],uint256,address)';

// Test from replayed transaction:
// https://etherscan.io/getRawTx?tx=0x2e7d1ace4b8ad78de74ecee794ec0b4466973b54c1235fbaeffe3fc37c8ef5ce

const rawTx = "0x02f90b3301228509175b02fc8509175b02fc830a95ba947fb69e8fb1525ceec03783ffd8a317bafbdfd39480b90ac4916a3bd9000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000001e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a00000000000000000000000000000000000000000000000000000000000000100000000000000000000000000425583989cb30d5af77da2e98480b15a71d9ebf30000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000001571ed0bed4d987fe2b498ddbae7dfa19519f651000000000000000000000000000000000000000000000000c6622e834b73cee100000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000030000000000000000000000000000000000000000000000000000000000000060000000000000000000000000000000000000000000000000000000000000014000000000000000000000000000000000000000000000000000000000000007e00000000000000000000000001571ed0bed4d987fe2b498ddbae7dfa19519f6510000000000000000000000001571ed0bed4d987fe2b498ddbae7dfa19519f6510000000000000000000000000000000000000000000000000000000000000080000000000000000000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000000242e1a7d4d000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000a0246c9032bc3a600820415ae600c6388619a14d000000000000000000000000def1c0ded9bec7f1a1670819833240f027b25eff0000000000000000000000000000000000000000000000000000000000000080ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00000000000000000000000000000000000000000000000000000000000005e4415565b0000000000000000000000000a0246c9032bc3a600820415ae600c6388619a14d000000000000000000000000c02aaa39b223fe8d0a0e5c4f27ead9083c756cc2ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00000000000000000000000000000000000000000000000003a6d1621389448000000000000000000000000000000000000000000000000000000000000000a00000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000003e000000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000000000034000000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a0246c9032bc3a600820415ae600c6388619a14d000000000000000000000000c02aaa39b223fe8d0a0e5c4f27ead9083c756cc200000000000000000000000000000000000000000000000000000000000001400000000000000000000000000000000000000000000000000000000000000300000000000000000000000000000000000000000000000000000000000000030000000000000000000000000000000000000000000000000000000000000002c0ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000300000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000c43727970746f436f6d0000000000000000000000000000000000000000000000000000000000000120ed896ca4f5200000000000000000000000000000000000000000000000000003c3bad3f4786651000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000000a0000000000000000000000000ceb90e4c17d626be0facd78b79c9c87d7ca181b300000000000000000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000000002000000000000000000000000a0246c9032bc3a600820415ae600c6388619a14d000000000000000000000000c02aaa39b223fe8d0a0e5c4f27ead9083c756cc2000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001c000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000000e00000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000000a00000000000000000000000000000000000000000000000000000000000000002000000000000000000000000a0246c9032bc3a600820415ae600c6388619a14d000000000000000000000000eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000c02aaa39b223fe8d0a0e5c4f27ead9083c756cc2000000000000000000000000c02aaa39b223fe8d0a0e5c4f27ead9083c756cc20000000000000000000000000000000000000000000000000000000000000080000000000000000000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000000242e1a7d4d000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000c001a0a26eaf6456059827f8512d89d98efd463e4782c41e87b887448dd8a890d4a02aa046a2012aede209e3100a1490ca3d7b2efa333d88ae1d21eb1cee21b3e32b97e3";
testRawTx(method, rawTx, 11, 5);

const params = [
    [[['0x1571eD0bed4D987fe2b498DdBaE7DFA19519F651', '14295039308668849889']],
    [['0x0000000000000000000000000000000000000000', 1]],
        '0x425583989cb30d5AF77dA2E98480b15A71D9ebf3',
        0,
        0],
    [['0x1571eD0bed4D987fe2b498DdBaE7DFA19519F651', '0x1571eD0bed4D987fe2b498DdBaE7DFA19519F651', '0x2e1a7d4d0000000000000000000000000000000000000000000000000000000000000001', 4],
    ['0xa0246c9032bC3A600820415aE600c6388619A14D', '0xDef1C0ded9bec7F1a1670819833240f027b25EfF', '0x415565b0000000000000000000000000a0246c9032bc3a600820415ae600c6388619a14d000000000000000000000000c02aaa39b223fe8d0a0e5c4f27ead9083c756cc2ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00000000000000000000000000000000000000000000000003a6d1621389448000000000000000000000000000000000000000000000000000000000000000a00000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000003e000000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000000000034000000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a0246c9032bc3a600820415ae600c6388619a14d000000000000000000000000c02aaa39b223fe8d0a0e5c4f27ead9083c756cc200000000000000000000000000000000000000000000000000000000000001400000000000000000000000000000000000000000000000000000000000000300000000000000000000000000000000000000000000000000000000000000030000000000000000000000000000000000000000000000000000000000000002c0ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000300000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000c43727970746f436f6d0000000000000000000000000000000000000000000000000000000000000120ed896ca4f5200000000000000000000000000000000000000000000000000003c3bad3f4786651000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000000a0000000000000000000000000ceb90e4c17d626be0facd78b79c9c87d7ca181b300000000000000000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000000002000000000000000000000000a0246c9032bc3a600820415ae600c6388619a14d000000000000000000000000c02aaa39b223fe8d0a0e5c4f27ead9083c756cc2000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001c000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000000e00000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000000a00000000000000000000000000000000000000000000000000000000000000002000000000000000000000000a0246c9032bc3a600820415ae600c6388619a14d000000000000000000000000eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0000000000000000000000000000000000000000000000000000000000000000', -1],
    ['0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2', '0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2', '0x2e1a7d4d0000000000000000000000000000000000000000000000000000000000000001', 4]],
    0,
    '0x0000000000000000000000000000000000000000'
]
// Test constructed tx
const abi = require('../harvest/abis/wido_router.abi.json');
testTx(addressbook.WIDO_ROUTER, abi, method, params, 9, 5);
