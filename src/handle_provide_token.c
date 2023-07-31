#include "harvest_plugin.h"

void handle_provide_token(void *parameters) {
    ethPluginProvideInfo_t *msg = (ethPluginProvideInfo_t *) parameters;
    context_t *context = (context_t *) msg->pluginContext;

    // Fill context wido from token ticker/decimals
    char *from_addr = context->contract_address;
    from_addr[0] = '0';
    from_addr[1] = 'x';

    uint64_t chainId = 0;

    getEthAddressStringFromBinary(context->from_address,
        from_addr + 2,  // +2 here because we've already prefixed with '0x'.
        msg->pluginSharedRW->sha3,
        chainId);
    if(from_addr == ZERO_ADDRESS) {
        strlcpy(context->from_address_ticker, "ETH", sizeof(context->from_address_ticker));
        context->from_address_decimals = 18;
    } else if (msg->item1 != NULL) {
        strlcpy(context->from_address_ticker, (char *) msg->item1->token.ticker, sizeof(context->from_address_ticker));
        context->from_address_decimals = msg->item1->token.decimals;
    } else {
        strlcpy(context->from_address_ticker, "???", sizeof(context->from_address_ticker));
        context->from_address_decimals = 18;
        msg->additionalScreens++;
    }
    msg->result = ETH_PLUGIN_RESULT_OK;
}
