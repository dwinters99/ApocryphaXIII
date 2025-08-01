import { Button, LabeledList, Section } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import { InterfaceLockNoticeBox } from './common/InterfaceLockNoticeBox';

export const TurretControl = (props) => {
  const { act, data } = useBackend();
  const locked = data.locked && !data.siliconUser;
  const { enabled, lethal, shootCyborgs } = data;
  return (
    <Window width={305} height={data.siliconUser ? 168 : 164}>
      <Window.Content>
        <InterfaceLockNoticeBox />
        <Section>
          <LabeledList>
            <LabeledList.Item label="Turret Status">
              <Button
                icon={enabled ? 'power-off' : 'times'}
                content={enabled ? 'Enabled' : 'Disabled'}
                selected={enabled}
                disabled={locked}
                onClick={() => act('power')}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Turret Mode">
              <Button
                icon={lethal ? 'exclamation-triangle' : 'minus-circle'}
                content={lethal ? 'Lethal' : 'Stun'}
                color={lethal ? 'bad' : 'average'}
                disabled={locked}
                onClick={() => act('mode')}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Target Cyborgs">
              <Button
                icon={shootCyborgs ? 'check' : 'times'}
                content={shootCyborgs ? 'Yes' : 'No'}
                selected={shootCyborgs}
                disabled={locked}
                onClick={() => act('shoot_silicons')}
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
