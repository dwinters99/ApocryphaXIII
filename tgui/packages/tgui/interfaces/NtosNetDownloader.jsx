import {
  Box,
  Button,
  Flex,
  Icon,
  LabeledList,
  NoticeBox,
  ProgressBar,
  Section,
} from 'tgui-core/components';

import { useBackend } from '../backend';
import { NtosWindow } from '../layouts';

export const NtosNetDownloader = (props) => {
  const { act, data } = useBackend();
  const {
    PC_device_theme,
    disk_size,
    disk_used,
    downloadable_programs = [],
    error,
    hacked_programs = [],
    hackedavailable,
  } = data;
  return (
    <NtosWindow theme={PC_device_theme} width={480} height={735} resizable>
      <NtosWindow.Content scrollable>
        {!!error && (
          <NoticeBox>
            <Box mb={1}>{error}</Box>
            <Button content="Reset" onClick={() => act('PRG_reseterror')} />
          </NoticeBox>
        )}
        <Section>
          <LabeledList>
            <LabeledList.Item label="Disk usage">
              <ProgressBar value={disk_used} minValue={0} maxValue={disk_size}>
                {`${disk_used} GQ / ${disk_size} GQ`}
              </ProgressBar>
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section>
          {downloadable_programs
            .filter((program) => program.access)
            .map((program) => (
              <Program key={program.filename} program={program} />
            ))}
          {downloadable_programs
            .filter((program) => !program.access)
            .map((program) => (
              <Program key={program.filename} program={program} />
            ))}
        </Section>
        {!!hackedavailable && (
          <Section title="UNKNOWN Software Repository">
            <NoticeBox mb={1}>
              Please note that Nanotrasen does not recommend download of
              software from non-official servers.
            </NoticeBox>
            {hacked_programs.map((program) => (
              <Program key={program.filename} program={program} />
            ))}
          </Section>
        )}
      </NtosWindow.Content>
    </NtosWindow>
  );
};

const Program = (props) => {
  const { program } = props;
  const { act, data } = useBackend();
  const {
    disk_size,
    disk_used,
    downloadcompletion,
    downloading,
    downloadname,
    downloadsize,
  } = data;
  const disk_free = disk_size - disk_used;
  return (
    <Box mb={3}>
      <Flex align="baseline">
        <Flex.Item bold grow={1}>
          {program.filedesc}
        </Flex.Item>
        <Flex.Item color="label" nowrap>
          {program.size} GQ
        </Flex.Item>
        <Flex.Item ml={2} width="94px" textAlign="center">
          {(program.filename === downloadname && (
            <ProgressBar
              color="green"
              minValue={0}
              maxValue={downloadsize}
              value={downloadcompletion}
            />
          )) || (
            <Button
              fluid
              icon="download"
              content="Download"
              disabled={
                downloading || program.size > disk_free || !program.access
              }
              onClick={() =>
                act('PRG_downloadfile', {
                  filename: program.filename,
                })
              }
            />
          )}
        </Flex.Item>
      </Flex>
      {program.compatibility !== 'Compatible' && (
        <Box mt={1} italic fontSize="12px" position="relative">
          <Icon mx={1} color="red" name="times" />
          Incompatible!
        </Box>
      )}
      {!program.access && (
        <Box mt={1} italic fontSize="12px" position="relative">
          <Icon mx={1} color="red" name="times" />
          Invalid credentials loaded!
        </Box>
      )}
      {program.size > disk_free && (
        <Box mt={1} italic fontSize="12px" position="relative">
          <Icon mx={1} color="red" name="times" />
          Not enough disk space!
        </Box>
      )}
      <Box mt={1} italic color="label" fontSize="12px">
        {program.fileinfo}
      </Box>
    </Box>
  );
};
