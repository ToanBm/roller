package set

import (
	"github.com/dymensionxyz/roller/relayer"
	"github.com/dymensionxyz/roller/sequencer"
	"github.com/dymensionxyz/roller/utils"
	configutils "github.com/dymensionxyz/roller/utils/config"
	"github.com/dymensionxyz/roller/utils/config/tomlconfig"
)

func setHubRPC(rlpCfg configutils.RollappConfig, value string) error {
	rlpCfg.HubData.RPC_URL = value
	if err := tomlconfig.Write(rlpCfg); err != nil {
		return err
	}
	if err := relayer.UpdateRlyConfigValue(
		rlpCfg, []string{"chains", rlpCfg.HubData.ID, "value", "rpc-addr"},
		value,
	); err != nil {
		return err
	}
	dymintTomlPath := sequencer.GetDymintFilePath(rlpCfg.Home)
	return utils.UpdateFieldInToml(dymintTomlPath, "settlement_node_address", value)
}
