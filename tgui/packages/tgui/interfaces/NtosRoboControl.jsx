import {
  Button,
  LabeledList,
  ProgressBar,
  Section,
  Stack,
} from 'tgui-core/components';

import { useBackend } from '../backend';
import { NtosWindow } from '../layouts';

const getMuleByRef = (mules, ref) => {
  return mules?.find((mule) => mule.mule_ref === ref);
};

export const NtosRoboControl = (props) => {
  const { act, data } = useBackend();
  const { bots, id_owner, has_id } = data;
  return (
    <NtosWindow width={550} height={550} resizable>
      <NtosWindow.Content scrollable>
        <Section title="Robot Control Console">
          <LabeledList>
            <LabeledList.Item label="Id Card">
              {id_owner}
              {!!has_id && (
                <Button
                  ml={2}
                  icon="eject"
                  content="Eject"
                  onClick={() => act('ejectcard')}
                />
              )}
            </LabeledList.Item>
            <LabeledList.Item label="Bots in range">
              {data.botcount}
            </LabeledList.Item>
          </LabeledList>
        </Section>
        {bots?.map((robot) => (
          <RobotInfo key={robot.bot_ref} robot={robot} />
        ))}
      </NtosWindow.Content>
    </NtosWindow>
  );
};

const RobotInfo = (props) => {
  const { robot } = props;
  const { act, data } = useBackend();
  const mules = data.mules || [];
  // Get a mule object
  const mule = !!robot.mule_check && getMuleByRef(mules, robot.bot_ref);
  // Color based on type of a robot
  const color =
    robot.mule_check === 1 ? 'rgba(110, 75, 14, 1)' : 'rgba(74, 59, 140, 1)';
  return (
    <Section
      title={robot.name}
      style={{
        border: `4px solid ${color}`,
      }}
      buttons={
        mule && (
          <>
            <Button
              icon="play"
              tooltip="Go to Destination."
              onClick={() =>
                act('go', {
                  robot: mule.mule_ref,
                })
              }
            />
            <Button
              icon="pause"
              tooltip="Stop Moving."
              onClick={() =>
                act('stop', {
                  robot: mule.mule_ref,
                })
              }
            />
            <Button
              icon="home"
              tooltip="Travel Home."
              tooltipPosition="bottom-left"
              onClick={() =>
                act('home', {
                  robot: mule.mule_ref,
                })
              }
            />
          </>
        )
      }
    >
      <Stack>
        <Stack.Item grow={1} basis={0}>
          <LabeledList>
            <LabeledList.Item label="Model">{robot.model}</LabeledList.Item>
            <LabeledList.Item label="Location">{robot.locat}</LabeledList.Item>
            <LabeledList.Item label="Status">{robot.mode}</LabeledList.Item>
            {mule && (
              <>
                <LabeledList.Item label="Loaded Cargo">
                  {data.load || 'N/A'}
                </LabeledList.Item>
                <LabeledList.Item label="Home">{mule.home}</LabeledList.Item>
                <LabeledList.Item label="Destination">
                  {mule.dest || 'N/A'}
                </LabeledList.Item>
                <LabeledList.Item label="Power">
                  <ProgressBar
                    value={mule.power}
                    minValue={0}
                    maxValue={100}
                    ranges={{
                      good: [60, Infinity],
                      average: [20, 60],
                      bad: [-Infinity, 20],
                    }}
                  />
                </LabeledList.Item>
              </>
            )}
          </LabeledList>
        </Stack.Item>
        <Stack.Item width="150px">
          {mule && (
            <>
              <Button
                fluid
                content="Set Destination"
                onClick={() =>
                  act('destination', {
                    robot: mule.mule_ref,
                  })
                }
              />
              <Button
                fluid
                content="Set ID"
                onClick={() =>
                  act('setid', {
                    robot: mule.mule_ref,
                  })
                }
              />
              <Button
                fluid
                content="Set Home"
                onClick={() =>
                  act('sethome', {
                    robot: mule.mule_ref,
                  })
                }
              />
              <Button
                fluid
                content="Unload Cargo"
                onClick={() =>
                  act('unload', {
                    robot: mule.mule_ref,
                  })
                }
              />
              <Button.Checkbox
                fluid
                content="Auto Return"
                checked={mule.autoReturn}
                onClick={() =>
                  act('autoret', {
                    robot: mule.mule_ref,
                  })
                }
              />
              <Button.Checkbox
                fluid
                content="Auto Pickup"
                checked={mule.autoPickup}
                onClick={() =>
                  act('autopick', {
                    robot: mule.mule_ref,
                  })
                }
              />
              <Button.Checkbox
                fluid
                content="Delivery Report"
                checked={mule.reportDelivery}
                onClick={() =>
                  act('report', {
                    robot: mule.mule_ref,
                  })
                }
              />
            </>
          )}
          {!mule && (
            <>
              <Button
                fluid
                content="Stop Patrol"
                onClick={() =>
                  act('patroloff', {
                    robot: robot.bot_ref,
                  })
                }
              />
              <Button
                fluid
                content="Start Patrol"
                onClick={() =>
                  act('patrolon', {
                    robot: robot.bot_ref,
                  })
                }
              />
              <Button
                fluid
                content="Summon"
                onClick={() =>
                  act('summon', {
                    robot: robot.bot_ref,
                  })
                }
              />
              <Button
                fluid
                content="Eject PAi"
                onClick={() =>
                  act('ejectpai', {
                    robot: robot.bot_ref,
                  })
                }
              />
            </>
          )}
        </Stack.Item>
      </Stack>
    </Section>
  );
};
