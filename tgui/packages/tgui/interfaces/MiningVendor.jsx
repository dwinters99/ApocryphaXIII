import { Box, Button, Section, Table } from 'tgui-core/components';
import { classes } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';

export const MiningVendor = (props) => {
  const { act, data } = useBackend();
  let inventory = [...data.product_records];
  return (
    <Window width={425} height={600} resizable>
      <Window.Content scrollable>
        <Section title="User">
          {(data.user && (
            <Box>
              Welcome, <b>{data.user.name || 'Unknown'}</b>,{' '}
              <b>{data.user.job || 'Unemployed'}</b>!
              <br />
              Your balance is <b>{data.user.points} dollars</b>.
            </Box>
          )) || (
            <Box color="light-gray">
              No registered ID card!
              <br />
              Please contact your local HoP!
            </Box>
          )}
        </Section>
        <Section title="Equipment">
          <Table>
            {inventory.map((product) => {
              return (
                <Table.Row key={product.name}>
                  <Table.Cell>
                    <span
                      className={classes(['vending32x32', product.path])}
                      style={{
                        'vertical-align': 'middle',
                      }}
                    />{' '}
                    <b>{product.name}</b>
                  </Table.Cell>
                  <Table.Cell>
                    <Button
                      style={{
                        'min-width': '95px',
                        'text-align': 'center',
                      }}
                      disabled={!data.user || product.price > data.user.points}
                      content={product.price + ' dollars'}
                      onClick={() =>
                        act('purchase', {
                          ref: product.ref,
                        })
                      }
                    />
                  </Table.Cell>
                </Table.Row>
              );
            })}
          </Table>
        </Section>
      </Window.Content>
    </Window>
  );
};
